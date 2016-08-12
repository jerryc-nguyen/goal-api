namespace :fake do

  task :users => :environment do
    [1,2,3,4,5].each_with_index do |value, index|
      User.create(
        first_name: "User",
        last_name: "No #{index}",
        token: "user#{index}"
      )
    end
  end

  task :connect => :environment do
    ActiveRecord::Base.transaction do
      u1 = User.all.limit(1).first
      u2 = User.all.offset(1).limit(1).first
      u3 = User.all.offset(2).limit(1).first
      u4 = User.all.offset(3).limit(1).first
      u5 = User.all.offset(4).limit(1).first

      u1.invite u2
      u1.invite u3
      u1.invite u4

      u2.invite u3
      
      u2.invite u4
      u3.invite u4

      u3.invite u1
      u1.approve_all_request!
      
      u5.invite u1
      u4.invite u1

      u2.approve_all_request!
      u3.approve_all_request!
      u4.approve_all_request!
    end
  end

end
