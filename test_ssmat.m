addpath("matlab/cmg/");
ssmats = split(strip(ls("suitesparse_mats/")));

for ssmi = 1:length(ssmats)
    ssm = ssmats{ssmi};

    % read/generate problem.
    M = load("suitesparse_mats/" + ssm).Problem.A;
    assert(size(M, 1) == size(M, 2));
    n = length(M);
    b = rand(n, 1);
    b = M * b;
    b = b / norm(b);

    % build icc solver
    perm = symrcm(M);
    Mperm = M(perm, perm);
    bperm = b(perm);
    Mlow = ichol(Mperm);

    % solve system.
    xperm = pcg(Mperm, bperm, 1e-8, 1000, Mlow, Mlow');
    x = zeros(n, 1);
    x(perm) = xperm;

    % check error.
    err = norm(M * x - b);
    assert(err <= 1e-8);
end
