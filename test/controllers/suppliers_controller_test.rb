require 'test_helper'

class SuppliersControllerTest < ActionController::TestCase
  setup do
    @supplier = suppliers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suppliers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supplier" do
    assert_difference('Supplier.count') do
      post :create, supplier: { AB: @supplier.AB, Account: @supplier.Account, BC: @supplier.BC, FC: @supplier.FC, IO: @supplier.IO, IQ: @supplier.IQ, MA: @supplier.MA, NB: @supplier.NB, NF: @supplier.NF, NS: @supplier.NS, NT: @supplier.NT, NU: @supplier.NU, ONT: @supplier.ONT, OU: @supplier.OU, PE: @supplier.PE, QC: @supplier.QC, SK: @supplier.SK, SubAccount: @supplier.SubAccount, SupplerName: @supplier.SupplerName, SupplierNo: @supplier.SupplierNo, YU: @supplier.YU, string: @supplier.string }
    end

    assert_redirected_to supplier_path(assigns(:supplier))
  end

  test "should show supplier" do
    get :show, id: @supplier
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @supplier
    assert_response :success
  end

  test "should update supplier" do
    patch :update, id: @supplier, supplier: { AB: @supplier.AB, Account: @supplier.Account, BC: @supplier.BC, FC: @supplier.FC, IO: @supplier.IO, IQ: @supplier.IQ, MA: @supplier.MA, NB: @supplier.NB, NF: @supplier.NF, NS: @supplier.NS, NT: @supplier.NT, NU: @supplier.NU, ONT: @supplier.ONT, OU: @supplier.OU, PE: @supplier.PE, QC: @supplier.QC, SK: @supplier.SK, SubAccount: @supplier.SubAccount, SupplerName: @supplier.SupplerName, SupplierNo: @supplier.SupplierNo, YU: @supplier.YU, string: @supplier.string }
    assert_redirected_to supplier_path(assigns(:supplier))
  end

  test "should destroy supplier" do
    assert_difference('Supplier.count', -1) do
      delete :destroy, id: @supplier
    end

    assert_redirected_to suppliers_path
  end
end
