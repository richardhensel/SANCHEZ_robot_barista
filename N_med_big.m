
function[NrBig, NrMed]=N_med_big(order);

NrBig=0;
NrMed=0;
j=2;
for i=2:order(1)
    
    cupsize=order(j)
    if cupsize==1
        NrMed=NrMed+1;
    elseif cupsize==2
        NrBig=NrBig+1;
    end
    j=j+6;
end