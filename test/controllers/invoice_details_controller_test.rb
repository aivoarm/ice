require 'test_helper'

class InvoiceDetailsControllerTest < ActionController::TestCase
  setup do
    @invoice_detail = invoice_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoice_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice_detail" do
    assert_difference('InvoiceDetail.count') do
      post :create, invoice_detail: { ACCOUNT_SEGMENT: @invoice_detail.ACCOUNT_SEGMENT, COST_CENTER_SEGMENT: @invoice_detail.COST_CENTER_SEGMENT, FILE_DATE: @invoice_detail.FILE_DATE, FILLER: @invoice_detail.FILLER, GST_AMOUNT: @invoice_detail.GST_AMOUNT, INVOICE_NUMBER: @invoice_detail.INVOICE_NUMBER, ITEM_AMOUNT: @invoice_detail.ITEM_AMOUNT, PROVINCE_TAX_CODE: @invoice_detail.PROVINCE_TAX_CODE, PST_AMOUNT: @invoice_detail.PST_AMOUNT, RECORD_TYPE: @invoice_detail.RECORD_TYPE, SOURCE: @invoice_detail.SOURCE, SUB_ACCOUNT_SEGMENT: @invoice_detail.SUB_ACCOUNT_SEGMENT, VENDOR_NUMBER: @invoice_detail.VENDOR_NUMBER, line_num: @invoice_detail.line_num, valid: @invoice_detail.valid }
    end

    assert_redirected_to invoice_detail_path(assigns(:invoice_detail))
  end

  test "should show invoice_detail" do
    get :show, id: @invoice_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice_detail
    assert_response :success
  end

  test "should update invoice_detail" do
    patch :update, id: @invoice_detail, invoice_detail: { ACCOUNT_SEGMENT: @invoice_detail.ACCOUNT_SEGMENT, COST_CENTER_SEGMENT: @invoice_detail.COST_CENTER_SEGMENT, FILE_DATE: @invoice_detail.FILE_DATE, FILLER: @invoice_detail.FILLER, GST_AMOUNT: @invoice_detail.GST_AMOUNT, INVOICE_NUMBER: @invoice_detail.INVOICE_NUMBER, ITEM_AMOUNT: @invoice_detail.ITEM_AMOUNT, PROVINCE_TAX_CODE: @invoice_detail.PROVINCE_TAX_CODE, PST_AMOUNT: @invoice_detail.PST_AMOUNT, RECORD_TYPE: @invoice_detail.RECORD_TYPE, SOURCE: @invoice_detail.SOURCE, SUB_ACCOUNT_SEGMENT: @invoice_detail.SUB_ACCOUNT_SEGMENT, VENDOR_NUMBER: @invoice_detail.VENDOR_NUMBER, line_num: @invoice_detail.line_num, valid: @invoice_detail.valid }
    assert_redirected_to invoice_detail_path(assigns(:invoice_detail))
  end

  test "should destroy invoice_detail" do
    assert_difference('InvoiceDetail.count', -1) do
      delete :destroy, id: @invoice_detail
    end

    assert_redirected_to invoice_details_path
  end
end
