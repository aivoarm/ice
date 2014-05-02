require 'test_helper'

class FileHeadersControllerTest < ActionController::TestCase
  setup do
    @file_header = file_headers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:file_headers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create file_header" do
    assert_difference('FileHeader.count') do
      post :create, file_header: { FILE_DATE: @file_header.FILE_DATE, INVOICE_AMOUNT: @file_header.INVOICE_AMOUNT, INVOICE_COUNT: @file_header.INVOICE_COUNT, RECORD_TYPE: @file_header.RECORD_TYPE, SOURCE: @file_header.SOURCE, TAX_VALIDATED: @file_header.TAX_VALIDATED, line_num: @file_header.line_num, valid: @file_header.valid }
    end

    assert_redirected_to file_header_path(assigns(:file_header))
  end

  test "should show file_header" do
    get :show, id: @file_header
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @file_header
    assert_response :success
  end

  test "should update file_header" do
    patch :update, id: @file_header, file_header: { FILE_DATE: @file_header.FILE_DATE, INVOICE_AMOUNT: @file_header.INVOICE_AMOUNT, INVOICE_COUNT: @file_header.INVOICE_COUNT, RECORD_TYPE: @file_header.RECORD_TYPE, SOURCE: @file_header.SOURCE, TAX_VALIDATED: @file_header.TAX_VALIDATED, line_num: @file_header.line_num, valid: @file_header.valid }
    assert_redirected_to file_header_path(assigns(:file_header))
  end

  test "should destroy file_header" do
    assert_difference('FileHeader.count', -1) do
      delete :destroy, id: @file_header
    end

    assert_redirected_to file_headers_path
  end
end
