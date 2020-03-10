# README

https://www.pluralsight.com/guides/handling-file-upload-using-ruby-on-rails-5-api

gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem 'jbuilder', '~> 2.7'
gem 'carrierwave', '~> 2.1'
gem 'carrierwave-base64', '~> 2.8'

#config/application.rb
module Fileuploadapp
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
    config.api_only = true
  end
end

bundle install

rails g scaffold Item name:string description:string

rails db:migrate

rails g uploader Picture
rails g migration add_picture_to_items picture:string

rails db:migrate

#app/uploaders/picture_uploader
def extension_white_list  
    %w(jpg jpeg gif png)
end

class Item < ApplicationRecord
 mount_uploader :picture, PictureUploader
end

 #app/controllers/items_controllerr.rb
 def item_params
  params.require(:item).permit(:name, :description :picture) # Add :picture as a permitted paramter
 end

 #app/views/items/show.json.jbuilder
json.extract! @item, :id, :name, :description, :picture, :created_at, :updated_at

rails g model document item:references document:string
rails g uploader Document

rails db:migrate

 #app/model/document.rb
class Document < ApplicationRecord
  belongs_to :item
  mount_uploader :document, DocumentUploader
end

#app/uploaders/document_uploader.rb
def extension_white_list
    %w(pdf)
end

#app/model/item.rb
class Item < ApplicationRecord
  mount_uploader :picture, PictureUploader
  has_many :documents
  attr_accessor :document_data
end

#app/controllers/item_controller.rb
def item_params
  params.require(:item).permit(:name, :description, :picture, :document_data => []) #add document_data as a permitted parameter
end

#app/controllers/item_controller.rb
 def create
   @item = Item.new(item_params)

   if @item.save
     #iterate through each of the files
     params[:item][:document_data].each do |file|
         @item.documents.create!(:document => file)
         #create a document associated with the item that has just been created
     end
     render :show, status: :created, location: @item
   else
     render json: @item.errors, status: :unprocessable_entity
   end
 end

 #app/views/items/show.json.jbuilder
json.extract! @item, :id, :name, :description, :picture, :documents, :created_at, :updated_at

# Gemfile.rb
gem 'carrierwave-base64'

bundle install

#app/models/item.rb
mount_base64_uploader :picture, PictureUploader

#app/models/document.rb
mount_base64_uploader :document, DocumentUploader


