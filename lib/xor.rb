#For protx Xor Encryption Xor.encrypt64("hello world","FxQDLMM6OAFGz3kJ")
#Thanks to blj from #rubyonrails for this beautifull and simple code
require 'base64'
class Xor
  def self.encrypt64(str, key)
    max = key.size-1; j = -1; xored = ""
    0.upto(str.size-1) do |i|
      j = j<max ? j+1 : 0
      xored << (str[i]).^(key[j])    
    end
    Base64.encode64(xored)
   end
end