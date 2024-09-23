function cost = CostFn(X, fn, t, lambda)
% dif_t = diff(t);
fn2 = gradient(gradient(fn, t),t);
% cost = sqrt(trapz(t,(X - fn).^2)) + lambda * trapz(t,fn2.^2);
% cost = sqrt(nansum((X - fn).^2,'all')) + lambda * trapz(t,fn2.^2);
% cost = sqrt(nansum((X - fn).^2,'all')) + lambda * trapz(t,fn2.^2);
cost = sqrt(nansum((X - fn).^2,'all')) + lambda * nansum(fn2.^2,'all');
% cost = sqrt(nansum((X - fn).^2,'all')) + lambda * trapz(t,(fn2).^2);
