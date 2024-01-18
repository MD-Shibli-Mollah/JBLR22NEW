SUBROUTINE BD.SOC.PARAM.ID
*-----------------------------------------------------------------------------
    !** FIELD definitions FOR BD.SOC.PARAM
*!
*Developer Info:
*    Date         : 13/02/2022
*    Description  : ID routine for the BD.SOC.PARAM template
*    Developed By : Md. Nazibul Islam
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*
*
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
    FN.PROP='F.AA.PROPERTY'
    F.PROP=''
*----------OPF---------
    EB.DataAccess.Opf(FN.PRD.GRP, F.PRD.GRP)
    EB.DataAccess.Opf(FN.PRD, F.PRD)
    EB.DataAccess.Opf(FN.PROP, F.PROP)
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
    EB.DataAccess.FRead(FN.PROP, Y.ID.P2, R.PROP, F.PROP, ERR.PROP)
    IF R.PROP EQ '' THEN
        EB.SystemTables.setE("PROPERTY DOES NOT EXIST")
        RETURN
    END
RETURN
END
