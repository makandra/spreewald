class DownloadsController < ApplicationController

  def spreadsheet
    send_data File.read("#{Rails.root}/public/fixture_files/spreadsheet.ods"), filename: 'test.ods'
  end

end
