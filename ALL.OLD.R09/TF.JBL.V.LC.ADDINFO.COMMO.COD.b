SUBROUTINE TF.JBL.V.LC.ADDINFO.COMMO.COD
*-----------------------------------------------------------------------------
* Attach Versions: LETTER.OF.CREDIT,JBL.BTB.AMD.JOB LETTER.OF.CREDIT,JBL.BTBAMDEXT LETTER.OF.CREDIT,JBL.BTBAMDINT
*                  LETTER.OF.CREDIT,JBL.BTBSIGHT  LETTER.OF.CREDIT,JBL.BTBUSANCE  LETTER.OF.CREDIT,JBL.EDFOPEN
*                  LETTER.OF.CREDIT,JBL.IMAMDINT  LETTER.OF.CREDIT,JBL.IMPSIGHT   LETTER.OF.CREDIT,JBL.IMPUSANCE
*------------------------------------------------------------------------------
* 10/28/2020 -                            Create by   - MAHMUDUR RAHMAN UDOY,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
* Description: In LC Applicatiion if commodity code field value but commodity name 1st filed not provid
*              then it populate the field from commodity application.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.LC.COMMODITY
    
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.Updates

    

   
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:

    
    Y.APP="LETTER.OF.CREDIT"
    Y.FLDS="LT.TF.COMMO.NM":VM:"LT.TF.COMMO.COD"
    Y.POS= ''
 
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.COMMO.NM.POS =Y.POS<1,1>
    Y.COMMO.COD.POS = Y.POS<1,2>
    
    
    
RETURN
   
OPENFILE:
    
    FN.COMM.COD='F.BD.LC.COMMODITY'
    F.COMM.COD = ''
   
RETURN
   
PROCESS:

    Y.COMMO.COD = EB.SystemTables.getComi()
    Y.COM.NM.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.COM.NM = Y.COM.NM.TEMP<1,Y.COMMO.NM.POS,1>
    IF Y.COMMO.COD NE '' AND Y.COM.NM EQ '' THEN
        EB.DataAccess.FRead(FN.COMM.COD, Y.COMMO.COD, REC.COMM, F.COMM.COD, REC.ERR)
        IF REC.COMM THEN
            Y.COMM.DES = REC.COMM<BD.DESCRIPTION>
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
            Y.TEMP<1,Y.COMMO.NM.POS,1> = Y.COMM.DES
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
        END
    END
     
       
      
RETURN


END
