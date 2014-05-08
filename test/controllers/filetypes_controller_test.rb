require 'test_helper'

class FiletypesControllerTest < ActionController::TestCase
  setup do
    @filetype = filetypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filetypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filetype" do
    assert_difference('Filetype.count') do
      post :create, filetype: { country: @filetype.country, ftype: @filetype.ftype }
    end

    assert_redirected_to filetype_path(assigns(:filetype))
  end

  test "should show filetype" do
    get :show, id: @filetype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @filetype
    assert_response :success
  end

  test "should update filetype" do
    patch :update, id: @filetype, filetype: { country: @filetype.country, ftype: @filetype.ftype }
    assert_redirected_to filetype_path(assigns(:filetype))
  end

  test "should destroy filetype" do
    assert_difference('Filetype.count', -1) do
      delete :destroy, id: @filetype
    end

    assert_redirected_to filetypes_path
  end
end
