

User = Struct.new(:first_name, :last_name, :active)
@users = []
@users << User.new("Jesse", "Wolgamott", false)
@users << User.new("Sam", "Cassel", true)
@users << User.new("Hakeem", "Olyjian", true)


class UserList
  def initialize(users)
    @users = users
  end

  def active_users
    @users.select {|user| user.active == true }
  end

  def for_each_user

    for user in active_users do
      yield user
    end

  end
end
user_list = UserList.new(@users)

def send_email_to_user(user)
  puts "---- Sending email to #{user.last_name}"
end

@users.each do |user|
  puts [user.last_name, user.first_name].join(", ")
end

user_list.for_each_user do |user|
  puts [user.last_name, user.first_name].join(", ")
end

#... later

user_list.for_each_user do |user|
  send_email_to_user(user)
end
