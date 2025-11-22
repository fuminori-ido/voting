namespace :voting do
  desc 'create dev data'
  task create_dev_data: :environment do
    raise 'Development env only' if !Rails.env.development?

    match   = Match.not_deleted.find_by_name('1st match court-a')
    cand_d  = Candidate.not_deleted.find_by_name('Esq.d')
    cand_e  = Candidate.find_or_create_by!(
                name: 'E-san')
    MatchCandidate.not_deleted.find_or_create_by!(
      match:      match,
      candidate:  cand_d
    )
    MatchCandidate.not_deleted.find_or_create_by!(
      match:      match,
      candidate:  cand_e
    )
    Vote.destroy_all
  end

  # load avaar image from IMAGE_DIR/[name].png
  desc 'load photo'
  task load_photo: :environment do
    raise 'Development or Performance only'      if !(Rails.env.development? || Rails.env.performance?)
    raise "ENV['IMAGE_DIR'] not set"  if ENV['IMAGE_DIR'].nil?

    Candidate.not_deleted.find_each do |c|
      expected_png_path = ENV['IMAGE_DIR'] + '/' + c.name + '.png'
      if File.exist?(expected_png_path)
        File.open(expected_png_path) do |f|
          c.avatar = f
          c.save!
        end
      else
        printf("image '%s' not exist.\n", expected_png_path)
      end
    end
  end
end
