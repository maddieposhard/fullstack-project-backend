# frozen_string_literal: true

class BookBlueprint < Blueprinter::Base
    identifier :id

    fields :title, :author, :read, :cover_image_url
end
