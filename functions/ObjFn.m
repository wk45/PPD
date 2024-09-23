function cost = ObjFn(X,param,b,M,t,rho,temp_idx)

    fn_est = Fn_Reconstruction(param,b,M,t,temp_idx);
    cost = CostFn(X, fn_est, t, rho);

end
