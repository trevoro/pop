class Screenshot < ApplicationRecord
  has_attached_file :image,
    styles: { thumb: ["64x64#", :jpg], :large => "750x" },
    :url => "/system/:class/:folder1/:folder2/:style/:file_name.:extension"

  validates_attachment :image, presence: true,
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] },
    size: { in: 0..3.megabytes }

  private

  Paperclip.interpolates :folder1 do |attachment, style|
    return attachment.hash_key[0,2]
  end

  Paperclip.interpolates :folder2 do |attachment, style|
    return attachment.hash_key[2,4]
  end

  Paperclip.interpolates :file_name do |attachment, style|
    return attachment.hash_key[5,35]
  end

end
