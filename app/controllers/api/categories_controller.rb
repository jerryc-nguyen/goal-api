class Api::CategoriesController < ApiController
  before_action :authenticate!
  before_action :find_category, only: [ :show, :update, :destroy ]

  def index
    success(data: current_user.categories)
  end

  def show
    success(data: @category)
  end

  def create
    category = current_user.categories.create(categories_params)
    if category.valid?
      success(data: category)
    else
      error(message: category.errors.full_messages.to_sentence)
    end
  end

  def update
    if @category.update(categories_params)
      success(data: @category)
    else
      error(message: @category.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @category.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @category.errors.full_messages.to_sentence)
    end
  end

  private

  def find_category
    @category ||= current_user.categories.find(params[:id])
  end

  def categories_params
    @categories_params ||= params.require(:category).permit(*Settings.params_permitted.category)
  end

end
