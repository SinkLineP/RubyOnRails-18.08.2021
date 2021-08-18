NotifyBlogSubscribers = Struct.new(:post_id) do
  def perform
    post = Post.find(post_id)
    BlogSubscriber.find_each { |subscriber| CosmetologyMailer.notify_blog_subscriber(subscriber, post).deliver }
  end
end
