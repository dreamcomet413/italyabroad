require 'openssl'
require 'base64'
require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  apply_simple_captcha :message => " image and text were different", :add_to_base => true

  validates_presence_of     :login, :email, :name, :surname
 # validates_presence_of :telephone,:on=>:create,:message=>'Please supply a phone number so that we can call'
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 6..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_presence_of     :address,                    :if => :customer?
  #validates_presence_of     :cap,                        :if => :customer?
  validates_presence_of     :city,                       :if => :customer?
  validates_length_of       :login,                      :within => 3..40
  validates_length_of       :email,                      :within => 3..100
  validates_uniqueness_of   :login,  :case_sensitive => false
  validates_format_of       :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

 # validate :validate_phone_number,:on=>:create
  def validate_on_create
    if self.telephone.blank?
      errors.add_to_base("Please supply a phone number so we can call if there are any problems using this address")

    end
  end

  has_many :reviews
  has_many :reservation, :dependent => :destroy
  has_many :wish_lists, :dependent => :destroy
  has_many :ship_addresses, :dependent => :destroy
  has_many :forum_posts
  has_many :recipes
  belongs_to :photo, :class_name => "Photo", :foreign_key => "photo_id"
  has_many :orders
  has_many :comments
  has_many :followers
  has_many :wine_lists
  has_many :messages
  has_many :faqs
  has_many :testimonials

  before_save :encrypt_password

  # Relations with other tables
  belongs_to :type


  after_create do |record|
    #Notifier.deliver_activation(record) #Customers don't wont activation by mail hum
    if record.type.name != "Guest"
      Notifier.deliver_account_created(record)
    end
  end

  after_update do |record|
    #Notifier.deliver_update(record)
  end


  def group
    self.type_id == 1 ? "Admin" : "Member"
  end

  named_scope :admins, :conditions => {:type_id => 1}, :order => "created_at DESC"
named_scope :regulars, :conditions => ['type_id = ? or type_id = ? or type_id = ?', 2,4,3], :order => "created_at DESC"

  def full_name
    str = ""
    str = "#{name.titleize} #{surname.titleize}" unless name.nil? and surname.nil?
  end

  def set_photo_from_upload(params_photo)
    photo = Photo.new(params_photo)
    if photo.save
      self.photo_id = photo.id
      self.photo_default = nil
      self.save
  end
  end

  def get_photo_default(size)
    (size=="small") ? "#{self.photo_default.downcase}.jpg" : "#{self.photo_default.downcase}_big.jpg"
  end



  def saved_to_winelist?(product)
    self.wine_lists.collect(&:product_id).include?(product.id)
  end

  def followed_by?(follower)
    self.followers.collect(&:follower_id).include?(follower.id)
  end

  def has_default_photo?
    !self.photo_default.blank?
  end

  def has_photo?
    self.photo
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login.strip) # need to get the salt
    unless u.nil?
    if  u.type_id.to_i != 4
      u && u.authenticated?(password.strip) ? u : nil
    else
        if u.active == true and u.authenticated?(password.strip)
        return u

      else
        return nil
      end
    end
  end
  end

  def set_last_seen_at
    self.last_seen_at = Time.now
    save(false)
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    enc = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC')
    enc.encrypt(salt)
    data = enc.update(password)
    Base64.encode64(data << enc.final)
  rescue
    nil
  end

  def self.update_posts_count(user_id)
    begin
      user = find(user_id)
      user.posts_count +=1
      user.save
    rescue => e
      logger.info "#########Unexpected error: #{e.inspect}"
    end
  end

  def admin?
    self.type_id == 1
  end

  def moderator_of?(forum_id)
    Moderatorship.find(:first, :conditions => [ "forum_id = ? AND user_id = ?", forum_id,  self.id ])
  end

  def display_name
    begin
      rv = name.blank? ? surname : name
      rv.humanize
    rescue => e
      logger.info "############# \nerror when displaying username for forums #{e.inspect}\n"
      ""
    end
  end

  def password_clean
    unless @password
      enc = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC')
      enc.decrypt(salt)
      text = enc.update(Base64.decode64(crypted_password))
      @password = (text << enc.final)
    end
    @password
  rescue
    nil
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    password_clean.downcase == password.downcase
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

  def default_ship_address
    self.ship_addresses.new(
      :code => "Default",
      # :name => self.full_name,  # full_name attribute is not exist in our database.
      :name => self.name,
      :telephone => self.telephone,
      :city => self.city,
      :address => self.address,
      :address_2 => self.address_2,
      :country => self.country,
      :cap => self.cap,
      :note => self.note,
      :is_new => false)
  end

  def find_total_points(user)
    return user.orders.map {|o| o.total}.sum.to_f * Setting.find(:first).points_per_pound
  end

  protected
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password.strip)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def customer?
    return type_id == 1 ? false : true
  end
end

