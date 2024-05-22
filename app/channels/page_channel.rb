class PageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "channel_schedule"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
