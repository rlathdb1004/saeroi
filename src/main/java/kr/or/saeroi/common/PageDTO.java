package kr.or.saeroi.common;
// 공통으로 사용할 클래스라서 common 패키지에 넣는다.

public class PageDTO {
    // 페이징 정보를 담는 클래스이다.

    private int page;
    // 현재 페이지 번호이다.

    private int size;
    // 한 페이지에 몇 개씩 보여줄지 정하는 값이다.

    private int totalCount;
    // DB에서 조회한 전체 데이터 개수이다.

    private int totalPage;
    // 전체 페이지 개수이다.

    private int startPage;
    // 화면에 보여줄 시작 페이지 번호이다.

    private int endPage;
    // 화면에 보여줄 끝 페이지 번호이다.

    private int blockSize = 5;
    // 페이지 번호를 몇 개씩 보여줄지 정한다.

    public PageDTO(int page, int size, int totalCount) {
        // Controller에서 현재 페이지, 보기 개수, 전체 개수를 받아온다.

        if (page < 1) {
            // page가 1보다 작게 들어오면 잘못된 값이다.
            page = 1;
            // 잘못된 page 값은 1페이지로 바꾼다.
        }

        if (size != 5 && size != 10 && size != 20 && size != 30) {
            // size가 5, 10, 20, 30이 아니면 잘못된 값이다.
            size = 5;
            // 잘못된 size 값은 기본값 10으로 바꾼다.
        }

        if (totalCount < 0) {
            // 전체 개수가 음수일 수는 없다.
            totalCount = 0;
            // 잘못된 전체 개수는 0으로 바꾼다.
        }

        this.page = page;
        // 현재 페이지 값을 저장한다.

        this.size = size;
        // 한 페이지에 보여줄 개수를 저장한다.

        this.totalCount = totalCount;
        // 전체 데이터 개수를 저장한다.

        this.totalPage = (int) Math.ceil((double) totalCount / size);
        // 전체 데이터 개수를 size로 나누어서 전체 페이지 수를 계산한다.

        if (this.totalPage == 0) {
            // 데이터가 하나도 없으면 전체 페이지가 0이 될 수 있다.
            this.totalPage = 1;
            // 화면 처리를 편하게 하기 위해 최소 1페이지로 만든다.
        }

        if (this.page > this.totalPage) {
            // 현재 페이지가 마지막 페이지보다 크면 잘못된 값이다.
            this.page = this.totalPage;
            // 현재 페이지를 마지막 페이지로 바꾼다.
        }

        this.startPage = ((this.page - 1) / blockSize) * blockSize + 1;
        // 화면에 보여줄 시작 페이지 번호를 계산한다.

        this.endPage = this.startPage + blockSize - 1;
        // 화면에 보여줄 끝 페이지 번호를 계산한다.

        if (this.endPage > this.totalPage) {
            // 끝 페이지 번호가 전체 페이지보다 크면 안 된다.
            this.endPage = this.totalPage;
            // 끝 페이지 번호를 전체 페이지 번호로 맞춘다.
        }
    }

    public int getPage() {
        // 현재 페이지 번호를 꺼내는 메소드이다.
        return page;
    }

    public int getSize() {
        // 한 페이지에 보여줄 개수를 꺼내는 메소드이다.
        return size;
    }

    public int getTotalCount() {
        // 전체 데이터 개수를 꺼내는 메소드이다.
        return totalCount;
    }

    public int getTotalPage() {
        // 전체 페이지 개수를 꺼내는 메소드이다.
        return totalPage;
    }

    public int getStartPage() {
        // 시작 페이지 번호를 꺼내는 메소드이다.
        return startPage;
    }

    public int getEndPage() {
        // 끝 페이지 번호를 꺼내는 메소드이다.
        return endPage;
    }

    public int getPrevPage() {
        // 이전 페이지 번호를 꺼내는 메소드이다.
        return page - 1;
    }

    public int getNextPage() {
        // 다음 페이지 번호를 꺼내는 메소드이다.
        return page + 1;
    }

    public boolean getHasPrev() {
        // 이전 페이지가 있는지 확인하는 메소드이다.
        return page > 1;
    }

    public boolean getHasNext() {
        // 다음 페이지가 있는지 확인하는 메소드이다.
        return page < totalPage;
    }
}