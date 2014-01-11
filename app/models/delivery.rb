# -*- coding: utf-8 -*-
class Delivery < ActiveRecord::Base
  validates_numericality_of :price
  validates_presence_of :name

  def name_with_price
    return name + " £" + price.to_s
  end

 # def validate
 #   errors.add('Price', 'must be greater than zero pound') if price <= 0
 # end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

