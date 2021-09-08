function [weight_t_updata,weight_b_updata]=ART1_learn(train_data_active,weight_t_active,weight_b_active)
   weight_t_updata=train_data_active .* weight_t_active;
   weight_b_updata=weight_t_updata./(0.5+sum(weight_t_updata));
end