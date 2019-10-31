# frozen_string_literal: true

class TestsController < ApplicationController
  before_action :find_test, only: %i[edit update show destroy start]
  before_action :find_user, only: %i[start]
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  def index
    @tests = Test.all
  end

  def new
    @test = Test.new
  end

  def edit; end

  def create
    @test = Test.new(test_params)
    if @test.save
      redirect_to tests_path
    else
      render :new
    end
  end

  def update
    if @test.update(test_params)
      redirect_to tests_path
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @test.destroy
    redirect_to tests_path
  end

  def start
    @user.tests.push(@test)
    redirect_to @user.test_passage(@test)
  end

  private

  def rescue_with_test_not_found
    render plain: 'Test not found'
  end

  def find_test
    @test = Test.find(params[:id])
  end

  def find_user
    @user = @current_user
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id, :user_id)
  end
end
