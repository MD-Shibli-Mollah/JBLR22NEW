SUBROUTINE TF.JBL.E.BLD.IMP.LC(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.LC.BD.BTBRECORD
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>='LC.TYPE'
    ENQ.DATA<3,Y.POS>='EQ'
    ENQ.DATA<4,Y.POS>='CCSF CCSL CCUF CCUL CISF CISL CIUF CIUL CSCF CSCL CSNE CSNF CSNI CSNL CSNT CSNZ CSPE CSPF CSPI CSPL CSPT CSPZ CUAE CUAF CUAI CUAL CUAT CUAZ CUCF CUCL CUNE CUNF CUNI CUNL CUNT CUNZ IACF IACL IDTF IFDC IFDO IFDU IFMC IFMU IFSC IFSO IFSU IISC IMCF IMCL IZDC IZSC'
RETURN
*** </region>
END
