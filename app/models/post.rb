# frozen_string_literal: true

# doc comment
class Post < ActiveRecord::Base
  set_table_name 'wp_posts'
  set_primary_key 'ID'
  attr_accessible :post_parent, :post_type, :post_modified, :post_status, :post_date
  has_many :comments, class_name: 'Comment', foreign_key: 'comment_post_ID'
  scope :published, where(post_status: 'publish', post_type: 'post').order('post_date DESC')
  scope :latest, ->(how_many) { published.order('post_date DESC').limit(how_many) }

  # use for searching with solr/sunspot
  # searchable do
  #   text :post_title, :post_content
  #   string :post_title, :post_content
  #   time :post_date
  #   string :post_status
  #   boolean :is_live, :using => :is_live?
  # end

  def live?
    post_status == 'publish'
  end

  def permalink
    permalink_structure = Option.get('permalink_structure')
    structure = permalink_structure.split('/')
    structure.delete_at(0)
    plink = '/'
    structure.each do |part|
      case part
      when '%year%'
        plink << post_date.to_s[0, 4]
      when '%monthnum%'
        plink << post_date.to_s[5, 2]
      when '%day%'
        plink << post_date.to_s[8, 2]
      when '%hour%'
      when '%minute%'
      when '%second%'
      when '%postname%'
        plink << post_name
      when '%post_id%'
      when '%category%'
      when '%tag%'
      when '%author%'
      end
      plink << '/'
    end
    plink = plink.chop
    plink
  end

  def self.get_from_permalink(params)
    # recreate permalink and check against guid in DB
    permalink_structure = Option.get('permalink_structure')
    structure = permalink_structure.split('/')
    structure.delete_at(0)
    plink = Option.get('siteurl')
    structure.each do |part|
      case part
      when '%year%'
        plink << params['year']
      when '%monthnum%'
        plink << params['monthnum']
      when '%day%'
        plink << params['day']
      when '%hour%'
        plink << params['hour']
      when '%minute%'
        pli << params['minute']
      when '%second%'
        plink << params['second']
      when '%postname%'
        plink << params['postname']
      when '%post_id%'
        plink << params['id']
      when '%category%'
        plink << params['category']
      when '%tag%'
        plink << params['tag']
      when '%author%'
        plink << params['author']
      end
      plink << '/'
    end
    plink = plink.chop
    # Rails.logger.debug { "Permalink of Post: #{plink}" }
    post = Post.published.where(guid: plink).first
    # TODO: TBH, I think the method below is faster, because it's a straight
    # SQL call. But it relies on the date being present in the permalink.
    if post.nil?
      post = Post
             .published
             .where(post_name: params['postname'])
             .where('post_date LIKE ?', "%#{params['year']}-#{params['monthnum']}-#{params['day']}%")
             .first
    end
    post
  end

  def content
    post_content
  end

  def clean_content
    content.gsub(%r{\[/?[^>]*\]}, '')
  end

  def title
    post_title
  end

  def datemark; end
end
