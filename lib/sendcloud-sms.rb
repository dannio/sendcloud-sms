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

    def self.sign(params)
      param_str = "#{@api_key}&"
      params.sort {|a, b| a.to_s <=> b.to_s}.map { |item| param_str << "#{item[0]}=#{item[1]}&" }
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

    def self.get(templateId)
      # signature requires template
      params = {
        smsUser: @user,
        templateIdStr: templateId,
        signature: sign({
            smsUser: @user,
            templateIdStr: templateId
        })
      }
      response = RestClient.get 'http://www.sendcloud.net/smsapi/get?', params: params
      JSON.parse(response.to_s)
    end

    def self.list
      params = {
        smsUser: @user,
        signature: sign({
            smsUser: @user,
        })
      }
      response = RestClient.get 'http://www.sendcloud.net/smsapi/list?', params: params
      JSON.parse(response.to_s)
    end

    def self.create(templateName, templateText, signName, signPositionStr, smsTypeStr)
      signature = sign({
          smsUser: @user,
          templateName: templateName,
          templateText: templateText,
          signName: signName,
          signPositionStr: signPositionStr,
          smsTypeStr: smsTypeStr,
      })
      response = RestClient.post 'http://www.sendcloud.net/smsapi/addsms?',
                                  smsUser: @user,
                                  templateName: templateName,
                                  templateText: templateText,
                                  signName: signName,
                                  signPositionStr: signPositionStr,
                                  smsTypeStr: smsTypeStr,
                                  signature: signature
      JSON.parse(response.to_s)
    end

    def self.update(templateId, templateName, templateText, signName, signPositionStr, smsTypeStr)
      signature = sign({
          smsUser: @user,
          templateIdStr: templateId,
          templateName: templateName,
          templateText: templateText,
          signName: signName,
          signPositionStr: signPositionStr,
          smsTypeStr: smsTypeStr,
      })
      response = RestClient.post 'http://www.sendcloud.net/smsapi/updatesms?',
                                  smsUser: @user,
                                  templateIdStr: templateId,
                                  templateName: templateName,
                                  templateText: templateText,
                                  signName: signName,
                                  signPositionStr: signPositionStr,
                                  smsTypeStr: smsTypeStr,
                                  signature: signature
      JSON.parse(response.to_s)['statusCode']
    end

    def self.submit(templateId)
      signature = sign({
          smsUser: @user,
          templateIdStr: templateId
      })
      response = RestClient.post 'http://www.sendcloud.net/smsapi/submitsms?',
                                  smsUser: @user,
                                  templateIdStr: templateId,
                                  signature: signature
      JSON.parse(response.to_s)
    end

    def self.delete(templateId)
      signature = sign({
          smsUser: @user,
          templateIdStr: templateId
      })
      response = RestClient.post 'http://www.sendcloud.net/smsapi/deletesms?',
                                  smsUser: @user,
                                  templateIdStr: templateId,
                                  signature: signature
      JSON.parse(response.to_s)['statusCode']
    end

    def self.get_signature(signId)
      params = {
        smsUser: @user,
        id: signId,
        signature: sign({
            smsUser: @user,
            id: signId,
        })
      }
      response = RestClient.get 'http://www.sendcloud.net/smsapi/sign/get?', params: params
      JSON.parse(response.to_s)
    end

    def self.list_signatures
      params = {
        smsUser: @user,
        signature: sign({
            smsUser: @user,
        })
      }
      response = RestClient.get 'http://www.sendcloud.net/smsapi/sign/list?', params: params
      JSON.parse(response.to_s)
    end

    def self.update_signature(signId, signType, signName)
      signature = sign({
          smsUser: @user,
          id: signId,
          signType: signType,
          signName: signName
      })
      response = RestClient.post 'http://www.sendcloud.net/smsapi/sign/update?',
                                  smsUser: @user,
                                  id: signId,
                                  signType: signType,
                                  signName: signName,
                                  signature: signature
      JSON.parse(response.to_s)['statusCode']
    end

    def self.create_signature(signType, signName)
      signature = sign({
          smsUser: @user,
          signType: signType,
          signName: signName
      })
      response = RestClient.post 'http://www.sendcloud.net/smsapi/sign/save?',
                                  smsUser: @user,
                                  signType: signType,
                                  signName: signName,
                                  signature: signature
      JSON.parse(response.to_s)
    end
  end
end