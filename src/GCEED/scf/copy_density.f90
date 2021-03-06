!
!  Copyright 2017-2019 SALMON developers
!
!  Licensed under the Apache License, Version 2.0 (the "License");
!  you may not use this file except in compliance with the License.
!  You may obtain a copy of the License at
!
!      http://www.apache.org/licenses/LICENSE-2.0
!
!  Unless required by applicable law or agreed to in writing, software
!  distributed under the License is distributed on an "AS IS" BASIS,
!  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!  See the License for the specific language governing permissions and
!  limitations under the License.
!
subroutine copy_density
use scf_data
implicit none
integer :: iiter
integer :: is
integer :: ix,iy,iz

if(Miter==1)then
!$OMP parallel do private(iz,iy,ix)
  do iz=ng_sta(3),ng_end(3)
  do iy=ng_sta(2),ng_end(2)
  do ix=ng_sta(1),ng_end(1)
    rho_in(ix,iy,iz,num_rho_stock+1)=rho(ix,iy,iz)
  end do
  end do
  end do
  if(ilsda==1)then
!$OMP parallel do private(iz,iy,ix)
    do iz=ng_sta(3),ng_end(3)
    do iy=ng_sta(2),ng_end(2)
    do ix=ng_sta(1),ng_end(1)
      rho_s_in(ix,iy,iz,num_rho_stock+1,1:2)=rho_s(ix,iy,iz,1:2)
    end do
    end do
    end do
  end if
end if

do iiter=1,num_rho_stock
!$OMP parallel do private(iz,iy,ix)
  do iz=ng_sta(3),ng_end(3)
  do iy=ng_sta(2),ng_end(2)
  do ix=ng_sta(1),ng_end(1)
    rho_in(ix,iy,iz,iiter)=rho_in(ix,iy,iz,iiter+1)
  end do
  end do
  end do
end do
do iiter=1,num_rho_stock-1
!$OMP parallel do private(iz,iy,ix)
  do iz=ng_sta(3),ng_end(3)
  do iy=ng_sta(2),ng_end(2)
  do ix=ng_sta(1),ng_end(1)
    rho_out(ix,iy,iz,iiter)=rho_out(ix,iy,iz,iiter+1)
  end do
  end do
  end do
end do

if(ilsda==1)then
  do iiter=1,num_rho_stock
    do is=1,2
!$OMP parallel do private(iz,iy,ix)
      do iz=ng_sta(3),ng_end(3)
      do iy=ng_sta(2),ng_end(2)
      do ix=ng_sta(1),ng_end(1)
        rho_s_in(ix,iy,iz,iiter,is)=rho_s_in(ix,iy,iz,iiter+1,is)
      end do
      end do
      end do
    end do
  end do
  do iiter=1,num_rho_stock-1
    do is=1,2
!$OMP parallel do private(iz,iy,ix)
      do iz=ng_sta(3),ng_end(3)
      do iy=ng_sta(2),ng_end(2)
      do ix=ng_sta(1),ng_end(1)
        rho_s_out(ix,iy,iz,iiter,is)=rho_s_out(ix,iy,iz,iiter+1,is)
      end do
      end do
      end do
    end do
  end do
end if

end subroutine copy_density
