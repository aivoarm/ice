require 'test_helper'

class InvoiceHeadersControllerTest < ActionController::TestCase
  setup do
    @invoice_header = invoice_headers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoice_headers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice_header" do
    assert_difference('InvoiceHeader.count') do
      post :create, invoice_header: { COMPANY_CODE_SEGMENT: @invoice_header.COMPANY_CODE_SEGMENT, CURRENCY_CODE: @invoice_header.CURRENCY_CODE, FILE_DATE: @invoice_header.FILE_DATE, GST_AMOUNT: @invoice_header.GST_AMOUNT, INVOICE_AMOUNT: @invoice_header.INVOICE_AMOUNT, INVOICE_DATE: @invoice_header.INVOICE_DATE, INVOICE_NUMBER: @invoice_header.INVOICE_NUMBER, ITEM_AMOUNT: @invoice_header.ITEM_AMOUNT, PROVINCE_TAX_CODE: @invoice_header.PROVINCE_TAX_CODE, PST_AMOUNT: @invoice_header.PST_AMOUNT, RECORD_TYPE: @invoice_header.RECORD_TYPE, SOURCE: @invoice_header.SOURCE, TAX_VALIDATED: @invoice_header.TAX_VALIDATED, VENDOR_NUMBER: @invoice_header.VENDOR_NUMBER, VENDOR_SITE_CODE: @invoice_header.VENDOR_SITE_CODE, line_num: @invoice_header.line_num, valid: @invoice_header.valid }
    end

    assert_redirected_to invoice_header_path(assigns(:invoice_header))
  end

  test "should show invoice_header" do
    get :show, id: @invoice_header
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice_header
    assert_response :success
  end

  test "should update invoice_header" do
    patch :update, id: @invoice_header, invoice_header: { COMPANY_CODE_SEGMENT: @invoice_header.COMPANY_CODE_SEGMENT, CURRENCY_CODE: @invoice_header.CURRENCY_CODE, FILE_DATE: @invoice_header.FILE_DATE, GST_AMOUNT: @invoice_header.GST_AMOUNT, INVOICE_AMOUNT: @invoice_header.INVOICE_AMOUNT, INVOICE_DATE: @invoice_header.INVOICE_DATE, INVOICE_NUMBER: @invoice_header.INVOICE_NUMBER, ITEM_AMOUNT: @invoice_header.ITEM_AMOUNT, PROVINCE_TAX_CODE: @invoice_header.PROVINCE_TAX_CODE, PST_AMOUNT: @invoice_header.PST_AMOUNT, RECORD_TYPE: @invoice_header.RECORD_TYPE, SOURCE: @invoice_header.SOURCE, TAX_VALIDATED: @invoice_header.TAX_VALIDATED, VENDOR_NUMBER: @invoice_header.VENDOR_NUMBER, VENDOR_SITE_CODE: @invoice_header.VENDOR_SITE_CODE, line_num: @invoice_header.line_num, valid: @invoice_header.valid }
    assert_redirected_to invoice_header_path(assigns(:invoice_header))
  end

  test "should destroy invoice_header" do
    assert_difference('InvoiceHeader.count', -1) do
      delete :destroy, id: @invoice_header
    end

    assert_redirected_to invoice_headers_path
  end
end
