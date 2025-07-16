package DATN.repository.dtorepository;

import java.util.List;

import DATN.dto.dtodata.DTO_CREATE;
import DATN.dto.dtodata.DTO_DETAILS;

public interface dto_custom {
    void WBH_AD_CRT_THEMSP(DTO_CREATE dto);
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_1(int id_sp);
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_2();
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_3();
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_4();
    List<DTO_DETAILS> DATN_SEL_SP_DB00001_5();
    void DATN_CRE_GY_DB00002_0(DTO_CREATE dto);
    void DATN_UPD_SP_DB00001_6(DTO_CREATE dto);
    List<DTO_DETAILS> DATN_SEL_GY_DB00002_1(int p_pageNo, int p_pageSize);
}
