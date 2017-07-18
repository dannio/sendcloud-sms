require 'digest'
require 'rest-client'
require 'json'
require 'yaml'

module SendCloud
  class SMS

    def self.load!(file, environment)
      config = YAML.load_file(file)
      self.auth(config[environment.to_s]['user'], config[environment.to_s]['api_key'])
    end

    def self.auth(user, api_key)
      @user = user
      @api_key = api_key
    end

    def self.sign(attritutes)
      param_str = "#{@api_key}&"
      attritutes.sort {|a, b| a.to_s <=> b.to_s}.map { |item| param_str << "#{item[0]}=#{item[1]}&" }
      param_str << @api_key
      Digest::MD5.new.update(param_str)
    end

    def self.send(template, phone, vars)
      # signature requires template, phone, vars
      signature = sign({
          smsUser: @user,
          templateId: template,
          msgType: 0,
          phone: (phone.is_a?Array) ? phone.join(',') : phone,
          vars: vars.to_json
      })
      response = RestClient.post 'http://sendcloud.sohu.com/smsapi/send?',
                                 smsUser: @user,
                                 templateId: template,
                                 msgType: 0,
                                 phone: (phone.is_a?Array) ? phone.join(',') : phone,
                                 vars: vars.to_json,
                                 signature: signature
      JSON.parse(response.to_s)['statusCode']
    end

    def self.send_voice(phone, code)
      # signature requires phone, code
      signature = sign({
          smsUser: @user,
          phone: phone,
          code: code
      })
      response = RestClient.post 'http://sendcloud.sohu.com/smsapi/sendVoice?',
                                 smsUser: @user,
                                 phone: phone,
                                 code: code,
                                 signature: signature
      JSON.parse(response.to_s)['statusCode']
    end

    def self.get(template)
      # signature requires template
      signature = sign({
          smsUser: @user,
          templateId: template
      })
      response = RestClient.get 'http://www.sendcloud.net/smsapi/get?',
                                 smsUser: @user,
                                 templateId: template,
                                 signature: signature
      JSON.parse(response.to_s)['statusCode']
      
    end
  end
end