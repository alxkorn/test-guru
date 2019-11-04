# frozen_string_literal: true

class Admin::TestsController < Admin::BaseController
  before_action :find_test, only: %i[edit update show destroy start]
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  def index
    @tests = Test.all
  end

  def new
    @test = Test.new
  end

  def edit; end

  def create
    @test = current_user.created_tests.new(test_params)
    if @test.save
      redirect_to admin_tests_path
    else
      render :new
    end
  end

  def update
    if @test.update(test_params)
      redirect_to admin_tests_path
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @test.destroy
    redirect_to admin_tests_path
  end

  private

  def rescue_with_test_not_found
    render plain: 'Test not found'
  end

  def find_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id)
  end
end