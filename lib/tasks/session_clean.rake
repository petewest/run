namespace :sessions do
	desc "Clean non-permanent sessions not used in a week"
	task expire_non_permanent: :environment do
		Session.where("permanent = ? AND updated_at < ?", false, (Time.now.midnight - 1.week)).each { |session|
                        session.destroy
                }

	end
end
