require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:expected_book_structure) do
    {
      'id' => Integer,
      'title' => String,
      'author' => String,
      'read' => [true, false]
    }
  end

  describe "GET /index" do
    before do
      create_list(:book, 10)
      get "/books"
      @body = JSON.parse(response.body)
    end

    it "returns books" do
      @body.each do |book|
        expect(book.keys).to contain_exactly(*expected_book_structure.keys)
      end
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "does not return empty if books exist" do
      expect(@body).not_to be_empty
    end

    it "returns 10 books" do
      expect(@body.size).to eq(10)
    end
  end 

  describe "GET /show" do
    let(:book_id) { create(:book).id }

    before do
      get "/books/#{book_id}"
      @body = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@body.keys).to contain_exactly(*expected_book_structure.keys)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do  
    before do 
      post "/books", params: { book: attributes_for(:book, read: false) }
      @body = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@body.keys).to contain_exactly(*expected_book_structure.keys)
    end

    it "count of books should increase by 1" do
      expect(Book.count).to eq(1)
    end

    it "returns http success" do
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /update" do
    let (:book_id) { create(:book).id }

    before do
      put "/books/#{book_id}", params: { book: { title: "Updated Title" } }
      @body = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@body.keys).to contain_exactly(*expected_book_structure.keys)
    end

    it "checks if the title is updated" do
      expect(Book.find(book_id).title).to eq("Updated Title")
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /destroy" do
    let(:book_id) { create(:book).id }

    before do
      delete "/books/#{book_id}"
    end

    it "deletes the book" do
      expect(Book.exists?(book_id)).to be_falsey
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
