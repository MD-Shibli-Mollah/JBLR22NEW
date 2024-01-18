SUBROUTINE BD.INT.VIOLATION.PARAM.ID
*-----------------------------------------------------------------------------
    !** FIELD definitions FOR BD.INT.VIOLATION.PARAM
*<doc>
* Template for field definitions routine BD.INT.VIOLATION.PARAM.FIELDS
*Developer Info:
*    Date         : 20/02/2022
*    Description  : ID ROUTINE for the BD.INT.VIOLATION.PARAM template
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*
* </doc>
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $USING EB.SystemTables
    $USING EB.DataAccess
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
    Y.ID=EB.SystemTables.getComi()
    Y.ID.P1=FIELD(Y.ID,'-',1)
    Y.ID.P2=FIELD(Y.ID,'-',2)
*------INIT---------
    FN.PRD.GRP='F.AA.PRODUCT.GROUP'
    F.PRD.GRP=''
    FN.PRD='F.AA.PRODUCT'
    F.PRD=''
*----------OPF---------
    EB.DataAccess.Opf(FN.PRD.GRP, F.PRD.GRP)
    EB.DataAccess.Opf(FN.PRD, F.PRD)

*-------PROCESS------------
    EB.DataAccess.FRead(FN.PRD.GRP, Y.ID.P1, R.PRD.GRP, F.PRD.GRP, ERR.PRD.GRP)
    EB.DataAccess.FRead(FN.PRD, Y.ID.P1, R.PRD, F.PRD, ERR.PRD)
*---------------CHECKS IF THE 1ST HALF OF ID IS A PRODUCT/PRODUCT GROUP-------------------
    IF R.PRD.GRP EQ '' THEN
        IF R.PRD EQ '' THEN
            EB.SystemTables.setE("PRODUCT GROUP OR PRODUCT DOES NOT EXIST")
            RETURN
        END
    END
*------------IF ABOVE CHECKS ARE FALSE THEN CHECKS THE 2ND HALF OF ID IS A PROPERTY OR NOT-------------
    
RETURN
END

*    $INSERT I_COMMON
*    $INSERT I_EQUATE
*    $USING EB.SystemTables
**-----------------------------------------------------------------------------
** TODO Add logic to validate the id
** TODO Create an EB.ERROR record if you are creating a new error code
**-----------------------------------------------------------------------------
**E = 'EB-NOT.VALID.ID'
*    Y.ID.CHK.L = EB.SystemTables.getIdNew()
*    IF Y.ID.CHK.L NE 'SYSTEM' THEN
*
*        EB.SystemTables.setE('ID MUST BE SYSTEM')
*    END
*
*RETURN
*
*END
