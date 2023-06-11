function cross_point = cross_pt(m1,m2,b1,b2)

	det=(-m1+m2);
    
	inv_mat=(1/det)*[1 -1; -m2 -m1];	
   
	temp=inv_mat*[b1;b2];

    sol(1,1)=temp(1,1);
    sol(1,2)=temp(2,1);
    
    cross_point=sol;
    
end