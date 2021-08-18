module UserOath 
    extend ActiveSupport::Concern

        def create_authorization(auth)
            authorizations.create(provider: auth.provider, uid: auth.uid)
        end

        class_methods do 
            def find_for_oauth(auth)
                authorizations = Authorization
                                 .where(provider: auth.provider, uid: auth.uid)
                                 .first
                return authorizations.user if authorizations
            end
        end 
end