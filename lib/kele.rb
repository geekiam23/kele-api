require 'httparty'
require "json"
require_relative 'roadmap'

  class Kele
    include HTTParty
    include Roadmap
    attr_reader :auth_token
    base_uri "https://www.bloc.io/api/v1"

    def initialize(email, password)
      response = self.class.post("/sessions", body: {"email": email, "password": password})
      case response.code
        when 200
          puts "Great job, It is up and running!"
        when 404
          puts "Sorry! Try again."
        when 500...600
          puts "ERROR #{response.code}"
      end
      puts response.code
      @auth_token = response["auth_token"]
    end

    def get_me
      response = self.class.get("/users/me", headers: {"authorization" => @auth_token})
      @user_data = JSON.parse(response.body)
      @user_data
    end

    def get_mentor_availability(mentor_id)
      response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth_token})
      JSON.parse(response.body)
    end
  end
