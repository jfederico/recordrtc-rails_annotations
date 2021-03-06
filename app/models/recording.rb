class Recording < ApplicationRecord
  include VideoUploader[:video]

  belongs_to :account

  validates_presence_of :title, :description, :video

  # Make route URLs more obfuscated
  #def to_param
  #  name = video.id
  #  ext = name.length - ('.webm').length - 1
  #
  #  [id, name[0..ext]].join
  #end
end
