package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ItemDTO;
import kr.or.saeroi.dto.ProcessDTO;
import kr.or.saeroi.dto.ProcessDetailDTO;

/**
 * 공정관리 DAO
 *
 * 역할:
 * - Service에서 요청한 공정관리 DB 작업을 MyBatis Mapper로 전달한다.
 * - 실제 SQL은 ProcessMapper.xml에 작성한다.
 *
 * 연결 Mapper:
 * - namespace: process
 * - 파일명: ProcessMapper.xml
 *
 * 기준:
 * - 품목관리 ItemDAO 구조 기준
 * - BOM관리 BomDAO 구조 기준
 * - SqlSession 사용
 * - ServiceImpl 사용 안 함
 */
@Repository
public class ProcessDAO {

    /**
     * MyBatis SQL 실행 객체
     */
    @Autowired
    private SqlSession sqlSession;


    // =========================================================
    // 1. 공정 목록 / 상세
    // =========================================================

    /**
     * 공정 목록 조회
     *
     * 사용 위치:
     * - 기준정보관리 > 공정관리 목록 화면
     *
     * 호출 Mapper:
     * - process.selectProcessList
     */
    public List<ProcessDTO> selectProcessList(ProcessDTO processDTO) {
        return sqlSession.selectList("process.selectProcessList", processDTO);
    }


    /**
     * 공정 목록 총 건수 조회
     *
     * 사용 위치:
     * - 목록 상단 총 건수 표시
     * - Controller 페이징 계산
     *
     * 호출 Mapper:
     * - process.selectProcessCount
     */
    public int selectProcessCount(ProcessDTO processDTO) {
        return sqlSession.selectOne("process.selectProcessCount", processDTO);
    }


    /**
     * 공정 상세 조회
     *
     * 사용 위치:
     * - 공정 상세보기 페이지
     *
     * 조건:
     * - process.proc_id 기준 1건 조회
     *
     * 호출 Mapper:
     * - process.selectProcessDetail
     */
    public ProcessDTO selectProcessDetail(int procId) {
        return sqlSession.selectOne("process.selectProcessDetail", procId);
    }


    // =========================================================
    // 2. 공정 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 공정 등록
     *
     * 사용 위치:
     * - 공정 등록 모달 저장 처리
     *
     * 호출 Mapper:
     * - process.insertProcess
     */
    public int insertProcess(ProcessDTO processDTO) {
        return sqlSession.insert("process.insertProcess", processDTO);
    }


    /**
     * 공정 수정
     *
     * 사용 위치:
     * - 공정 상세 화면 수정 처리
     *
     * 호출 Mapper:
     * - process.updateProcess
     */
    public int updateProcess(ProcessDTO processDTO) {
        return sqlSession.update("process.updateProcess", processDTO);
    }


    /**
     * 공정 선택 삭제
     *
     * 처리 방식:
     * - process_detail 먼저 삭제
     * - process 삭제
     *
     * 이유:
     * - process_detail.proc_id2가 process.proc_id를 참조한다.
     * - 상세 데이터가 남아 있으면 process 삭제 시 FK 오류가 발생할 수 있다.
     *
     * 호출 Mapper:
     * - process.deleteProcessDetailByProcIdList
     * - process.deleteProcessList
     */
    public int deleteProcessList(List<Integer> procIdList) {

        sqlSession.delete("process.deleteProcessDetailByProcIdList", procIdList);

        return sqlSession.delete("process.deleteProcessList", procIdList);
    }


    /**
     * 공정코드 중복 확인
     *
     * 기준:
     * - proc_code 단독 중복검사
     * - 수정 시에는 현재 proc_id를 제외한다.
     *
     * 호출 Mapper:
     * - process.selectProcessDuplicateCount
     */
    public int selectProcessDuplicateCount(ProcessDTO processDTO) {
        return sqlSession.selectOne("process.selectProcessDuplicateCount", processDTO);
    }


    /**
     * 공정코드 자동완성 조회
     *
     * 사용 위치:
     * - 공정 등록 모달
     * - 공정 상세 수정 화면
     *
     * 기준:
     * - 기존 process.proc_code, process.proc_name 기준 조회
     *
     * 호출 Mapper:
     * - process.selectProcCodeAutoComplete
     */
    public List<ProcessDTO> selectProcCodeAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("process.selectProcCodeAutoComplete", paramMap);
    }


    // =========================================================
    // 3. 공정 이미지 / 공정상세 관리
    // =========================================================

    /**
     * 공정상세 목록 조회
     *
     * 사용 위치:
     * - 공정 상세보기 페이지 하단
     * - 공정 이미지 목록
     *
     * 조건:
     * - process_detail.proc_id2 = process.proc_id
     *
     * 호출 Mapper:
     * - process.selectProcessDetailList
     */
    public List<ProcessDetailDTO> selectProcessDetailList(int procId) {
        return sqlSession.selectList("process.selectProcessDetailList", procId);
    }


    /**
     * 공정상세 단건 조회
     *
     * 사용 위치:
     * - 공정상세 삭제 전 기존 이미지 경로 확인
     * - 공정상세 수정 전 기존 이미지 경로 확인
     *
     * 조건:
     * - process_detail.proc_id 기준 조회
     *
     * 호출 Mapper:
     * - process.selectProcessDetailOne
     */
    public ProcessDetailDTO selectProcessDetailOne(int procDetailId) {
        return sqlSession.selectOne("process.selectProcessDetailOne", procDetailId);
    }


    /**
     * 공정상세 등록
     *
     * 사용 위치:
     * - 공정 상세보기 페이지에서 이미지/설명 등록
     *
     * 저장 대상:
     * - proc_id2
     * - proc_picture
     * - proc_content
     * - remark
     *
     * 호출 Mapper:
     * - process.insertProcessDetail
     */
    public int insertProcessDetail(ProcessDetailDTO processDetailDTO) {
        return sqlSession.insert("process.insertProcessDetail", processDetailDTO);
    }


    /**
     * 공정상세 수정
     *
     * 사용 위치:
     * - 공정 이미지/설명 수정
     *
     * 설명:
     * - 새 이미지가 있으면 proc_picture까지 수정한다.
     * - 새 이미지가 없으면 기존 proc_picture는 유지한다.
     *
     * 호출 Mapper:
     * - process.updateProcessDetail
     */
    public int updateProcessDetail(ProcessDetailDTO processDetailDTO) {
        return sqlSession.update("process.updateProcessDetail", processDetailDTO);
    }


    /**
     * 공정상세 선택 삭제
     *
     * 사용 위치:
     * - 공정 상세보기 페이지의 공정 이미지 선택 삭제
     *
     * 조건:
     * - process_detail.proc_id 목록 기준 삭제
     *
     * 호출 Mapper:
     * - process.deleteProcessDetailList
     */
    public int deleteProcessDetailList(List<Integer> procDetailIdList) {
        return sqlSession.delete("process.deleteProcessDetailList", procDetailIdList);
    }


    /**
     * 공정상세 단건 삭제
     *
     * 사용 위치:
     * - 필요 시 단건 삭제용
     *
     * 호출 Mapper:
     * - process.deleteProcessDetailOne
     */
    public int deleteProcessDetailOne(int procDetailId) {
        return sqlSession.delete("process.deleteProcessDetailOne", procDetailId);
    }


    // =========================================================
    // 4. 완제품 / 설비 선택 데이터
    // =========================================================

    /**
     * 완제품 자동완성 조회
     *
     * 사용 위치:
     * - 현재는 selectbox 사용 기준이라 필수 기능은 아님
     * - 추후 자동완성 전환 시 사용 가능
     *
     * 대상:
     * - item_type = 'FG'
     *
     * 호출 Mapper:
     * - process.selectProductItemAutoComplete
     */
    public List<ItemDTO> selectProductItemAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("process.selectProductItemAutoComplete", paramMap);
    }


    /**
     * 완제품 선택 목록 조회
     *
     * 사용 위치:
     * - 공정 등록 모달
     * - 공정 상세 수정 화면
     *
     * 대상:
     * - item_type = 'FG'
     *
     * 호출 Mapper:
     * - process.selectProductItemList
     */
    public List<ItemDTO> selectProductItemList() {
        return sqlSession.selectList("process.selectProductItemList");
    }


    /**
     * 설비 자동완성 조회
     *
     * 사용 위치:
     * - 현재는 selectbox 사용 기준이라 필수 기능은 아님
     * - 추후 자동완성 전환 시 사용 가능
     *
     * 호출 Mapper:
     * - process.selectEquipmentAutoComplete
     */
    public List<ProcessDTO> selectEquipmentAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("process.selectEquipmentAutoComplete", paramMap);
    }


    /**
     * 설비 선택 목록 조회
     *
     * 사용 위치:
     * - 공정 등록 모달
     * - 공정 상세 수정 화면
     *
     * 호출 Mapper:
     * - process.selectEquipmentList
     */
    public List<ProcessDTO> selectEquipmentList() {
        return sqlSession.selectList("process.selectEquipmentList");
    }
}