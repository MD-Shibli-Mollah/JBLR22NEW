* @ValidationCode : MjoyMDA4NTAxODcxOkNwMTI1MjoxNzA0Nzk3OTUwNzMxOm5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 16:59:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE GB.JBL.E.BLD.RTN(ENQ.DATA)

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    !ENQ.DATA<2,-1> = 'REPORT.NAME'
    !ENQ.DATA<3,-1> = 'EQ'
    !ENQ.DATA<4,-1> = 'RC.CUS.SUPP2 RC.CUS.SUPP RC.CUS.SUP.CD.DR RC.CUS.SUP.CD.CR RC.CUS.SUP.SB.DR RC.CUS.SUP.SB.CR RC.CUS.SUP.SND.DR RC.CUS.SUP.SND.CR'
    ENQ.DATA<16> = "YES"
RETURN
END

