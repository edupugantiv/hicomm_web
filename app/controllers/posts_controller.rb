class PostsController<ApplicationController
	def new
		@post = Post.new
	end

	def create
		@group = Group.friendly.find(params[:id])
		@post = Post.create(post_params.merge(:poster_id => current_user.id, :group_id => @group.id, :posted => Time.now))
		redirect_to :back, notice: "your post was posted!"
	end

	private

	def post_params
		params.require(:post).permit(:body)
	end
end 