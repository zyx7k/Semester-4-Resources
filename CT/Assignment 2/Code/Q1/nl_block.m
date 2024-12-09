function output = nl_block(sig, a, b)
    output = a*sig + b*(sig.*sig);
end