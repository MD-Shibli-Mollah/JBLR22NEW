SUBROUTINE TF.JBL.E.BLD.AA.ARR.ACT.PC.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.AA.ARR.ACT.PC-NAU
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 16/11/2020 -                            Retrofit   - MD. SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON

*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>="PRODUCT"
    ENQ.DATA<3,Y.POS>="EQ"
    ENQ.DATA<4,Y.POS>="JBL.PACK.CR.COR.LN JBL.PACK.CR.COT.LN JBL.PACK.CR.ME.LN JBL.PACK.CR.MIC.LN JBL.PACK.CR.SE.LN JBL.PC.NR.COR.LN JBL.PC.NR.COT.LN JBL.PC.NR.ME.LN JBL.PC.NR.MIC.LN JBL.PC.NR.SE.LN"
RETURN
*** </region>

END
