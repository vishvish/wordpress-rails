class NewsController < ApplicationController

  def index  
    @page = params[ :page ].nil? ? 1 : params[ :page ]
    allposts = Post.published.all
    @posts = allposts.paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @post = Post.get_from_permalink( params )
  end
  
  def feed
    @posts = Post.latest( 10 )
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'feed', :layout => false, :template => 'feed'
  end

end

