require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/empresas", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Empresa. As you add validations to Empresa, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Empresa.create! valid_attributes
      get empresas_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      empresa = Empresa.create! valid_attributes
      get empresa_url(empresa)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_empresa_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      empresa = Empresa.create! valid_attributes
      get edit_empresa_url(empresa)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Empresa" do
        expect {
          post empresas_url, params: { empresa: valid_attributes }
        }.to change(Empresa, :count).by(1)
      end

      it "redirects to the created empresa" do
        post empresas_url, params: { empresa: valid_attributes }
        expect(response).to redirect_to(empresa_url(Empresa.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Empresa" do
        expect {
          post empresas_url, params: { empresa: invalid_attributes }
        }.to change(Empresa, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post empresas_url, params: { empresa: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested empresa" do
        empresa = Empresa.create! valid_attributes
        patch empresa_url(empresa), params: { empresa: new_attributes }
        empresa.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the empresa" do
        empresa = Empresa.create! valid_attributes
        patch empresa_url(empresa), params: { empresa: new_attributes }
        empresa.reload
        expect(response).to redirect_to(empresa_url(empresa))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        empresa = Empresa.create! valid_attributes
        patch empresa_url(empresa), params: { empresa: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested empresa" do
      empresa = Empresa.create! valid_attributes
      expect {
        delete empresa_url(empresa)
      }.to change(Empresa, :count).by(-1)
    end

    it "redirects to the empresas list" do
      empresa = Empresa.create! valid_attributes
      delete empresa_url(empresa)
      expect(response).to redirect_to(empresas_url)
    end
  end
end