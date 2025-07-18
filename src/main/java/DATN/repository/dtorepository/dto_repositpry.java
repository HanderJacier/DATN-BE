package DATN.repository.dtorepository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import DATN.dto.dtodata.DTO_CREATE;
import DATN.dto.dtodata.DTO_DETAILS;

@Repository
public class dto_repositpry implements dto_custom{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void WBH_AD_CRT_THEMSP(DTO_CREATE dto) {
        String sql = "EXEC WBH_AD_CRT_THEMSP ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

        jdbcTemplate.update(sql,
            dto.getTensanpham(),
            dto.getDongia(),
            dto.getLoai(),
            dto.getThuonghieu(),
            dto.getAnhgoc(),
            dto.getCpuBrand(),
            dto.getCpuModel(),
            dto.getCpuType(),
            dto.getCpuMinSpeed(),
            dto.getCpuMaxSpeed(),
            dto.getCpuCores(),
            dto.getCpuThreads(),
            dto.getCpuCache(),
            dto.getGpuBrand(),
            dto.getGpuModel(),
            dto.getGpuFullName(),
            dto.getGpuMemory(),
            dto.getRam(),
            dto.getRom(),
            dto.getScreen(),
            dto.getMausac(),
            dto.getSoluong(),
            dto.getDiachianh(),
            dto.getLoaigiam(),
            dto.getHangiamgia()
        );
    }

    @Override
    public List<DTO_DETAILS> DATN_SEL_SP_DB00001_1(int id_sp) {
        String sql = "EXEC DATN_SEL_SP_DB00001_1 ?";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(DTO_DETAILS.class),
            id_sp
        );
    }


    @Override
    public List<DTO_DETAILS> DATN_SEL_SP_DB00001_2() {
        String sql = "EXEC DATN_SEL_SP_DB00001_2";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(DTO_DETAILS.class)
        );
    }

    @Override
    public List<DTO_DETAILS> DATN_SEL_SP_DB00001_3() {
        String sql = "EXEC DATN_SEL_SP_DB00001_3";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(DTO_DETAILS.class)
        );
    }

    @Override
    public List<DTO_DETAILS> DATN_SEL_SP_DB00001_4() {
        String sql = "EXEC DATN_SEL_SP_DB00001_4";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(DTO_DETAILS.class)
        );
    }

    @Override
    public List<DTO_DETAILS> DATN_SEL_SP_DB00001_5() {
        String sql = "EXEC DATN_SEL_SP_DB00001_5";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(DTO_DETAILS.class)
        );
    }

    @Override
    public void DATN_CRE_GY_DB00002_0(DTO_CREATE dto) {
        String sql = "EXEC DATN_CRE_GY_DB00002_0 ?, ?";

        jdbcTemplate.update(sql,
            dto.getId_tk(),
            dto.getNoidung()  
        );
    }

    @Override
    public void DATN_UPD_SP_DB00001_6(DTO_CREATE dto) {
        String sql = "EXEC DATN_UPD_SP_DB00001_6 ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

        jdbcTemplate.update(sql,
            dto.getId_sp(),
            dto.getTensanpham(),
            dto.getDongia(),
            dto.getLoai(),
            dto.getThuonghieu(),
            dto.getAnhgoc(),
            dto.getCpuBrand(),
            dto.getCpuModel(),
            dto.getCpuType(),
            dto.getCpuMinSpeed(),
            dto.getCpuMaxSpeed(),
            dto.getCpuCores(),
            dto.getCpuThreads(),
            dto.getCpuCache(),
            dto.getGpuBrand(),
            dto.getGpuModel(),
            dto.getGpuFullName(),
            dto.getGpuMemory(),
            dto.getRam(),
            dto.getRom(),
            dto.getScreen(),
            dto.getMausac(),
            dto.getSoluong(),
            dto.getDiachianh()
        );
    }

    @Override
    public List<DTO_DETAILS> DATN_SEL_GY_DB00002_1(int p_pageNo, int p_pageSize) {
        String sql = "EXEC DATN_SEL_GY_DB00002_1 ?, ?";
        return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(DTO_DETAILS.class),
            p_pageNo,
            p_pageSize
        );
    }
}
