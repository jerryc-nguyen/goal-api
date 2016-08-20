class PushServices::Notifier

  def initialize(push_client = nil)
    @push_client = push_client || airship_client
  end

  def push(message: "Hello from Goal API Backend")
    airship_push_instance.notification = Urbanairship.notification(alert: message)
    airship_push_instance.send_push
  end

  private

  def airship_client
    @airship_client ||= Urbanairship::Client.new(key: Settings.push_notification.app_id, secret: Settings.push_notification.app_master_secret)
  end

  def airship_push_instance
    @airship_push_instance ||= begin
      p = airship_client.create_push
      p.audience = Urbanairship.all
      p.device_types = Urbanairship.all
      p
    end
  end

end
