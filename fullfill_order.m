function[cups] = fullfill_order(cups, i);
for 1:cups(i).Ncoffee;
    grab_order(1);
    release_order(cups,i);
end
for 1:cups(i).Ntea
    grab_order(2);
    release_order(cups,i);
end
for 1:cups(i).Nsugar
    grab_order(3);
    release_order(cups,i);
end
cups(i).IsDone = 1;
end
