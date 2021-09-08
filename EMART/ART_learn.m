function [weight_updata]=ART_learn(train_data , weight_activate)
   weight_updata= train_data.' .*  weight_activate;
end