class InvoicesController < ApplicationController
  #before_action :set_invoice, only: [:show, :edit, :update, :destroy, :delete_all]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
   
   Invoice.delete_all
   redirect_to "/invoices"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
            @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
     # params.require(:invoice).permit(:inv_n, :supplier, :inv_amt)
    end
end
