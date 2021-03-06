!
! $Id: init_global_variables_tasaki.f90,v 1.1 2003/04/30 12:26:15 k-yukino Exp $
!
#include "parameter.h"

subroutine init_global_variables_tasaki(number_unit,name,error)
  use global_variables
  implicit none
  
  type coordinate
     integer :: xaxis
     integer :: yaxis
  end type coordinate

  integer,intent(in) :: number_unit
  character(32),intent(out) :: name
  integer,intent(out) :: error
!
  type(coordinate),dimension(:),allocatable :: tmp_site_table
  integer :: i_count,j_count,k_count
  integer :: ier,temp1,temp2
! init
  name="init_global_variables_tasaki" ; error=0
  ier=0 ; temp1=0 ; temp2=0
  
! $B$3$l$G3NJ]$9$l$P$$$$%a%b%jNL$OJ,$+$C$?$N$G3NJ]$9$k!#(B
  allocate(tmp_site_table(TOTAL_SITE_NUMBER),stat=ier)
  call stat_check("tmp_site_table","init_global_variables_mielke",1,ier)
  tmp_site_table%xaxis=0 ; tmp_site_table%yaxis=0

!
! $B%i%F%#%9!&%]%$%s%H$N:BI8$r=q$-=P$9(B
!
  k_count=1

  do i_count=0,2*number_unit
     do j_count=0,2*number_unit
        if( mod(i_count+j_count,2)==0 ) then
           tmp_site_table(k_count)%xaxis=i_count
           tmp_site_table(k_count)%yaxis=j_count*(-1)
           k_count=k_count+1
        end if
     end do
  end do

!
! distance_table$B$r:n$k(B($B$d$O$j$3$3$G$N(Bdistance-table$B$b(Bsqrt$B$J$7$GDj5A(B)
!

  do i_count=1,TOTAL_SITE_NUMBER
     do j_count=1,i_count
        distance_table(i_count,j_count)=( (tmp_site_table(i_count)%xaxis &
             -tmp_site_table(j_count)%xaxis)**2&
             +(tmp_site_table(i_count)%yaxis-tmp_site_table(j_count)%yaxis)**2&
             )
        distance_table(j_count,i_count)=distance_table(i_count,j_count)
     end do
  end do

!
! $BNY@\%F!<%V%k$r:n$k(B
!
  do i_count=1,TOTAL_SITE_NUMBER
     do j_count=1,TOTAL_SITE_NUMBER
        if( distance_table(i_count,j_count)==4 .or. &
             distance_table(i_count,j_count)==2 ) then
           neighbor_table(i_count,j_count)=1
        else if( distance_table(i_count,j_count)==8 ) then
           neighbor_table(i_count,j_count)=2
        end if
     end do
  end do

end subroutine init_global_variables_tasaki
