module ArticlesHelper
    def day_time(datetime) 
        datetime.strftime('%B %e, %Y')
    end
end
