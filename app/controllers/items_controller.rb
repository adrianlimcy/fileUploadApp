class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy, :download_pdf]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  def download_pdf
    send_file(
      "#{Rails.root}/public/uploads/document/document/"+@item.id.to_s+"/test.pdf",
      filename: "cms_file.pdf",
      type: "application/pdf"
    )
  end

  # POST /items
  # POST /items.json
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

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      render :show, status: :ok, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :picture, :document_data => [])
    end
end
