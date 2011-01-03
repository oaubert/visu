/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package  com.ithaca.visu.model
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.model.TraceModel;
	import com.ithaca.traces.view.ObselImage;
	import com.ithaca.traces.view.ObselMarker;
	import com.ithaca.traces.view.ObselSessionOut;
	import com.ithaca.visu.model.vo.SessionVO;
	import com.ithaca.visu.model.vo.UserVO;
	import com.ithaca.visu.modules.VisuModuleBase;
	import com.ithaca.visu.ui.utils.ActionObselEnum;
	import com.ithaca.visu.ui.utils.ConnectionStatus;
	import com.ithaca.visu.ui.utils.IconEnum;
	import com.ithaca.visu.ui.utils.RoleEnum;
	
	import flash.net.NetConnection;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import spark.components.Button;


	public final class Model
	{

		/**
		 * Defines the Singleton instance of the Application Model
		 */
		private static var instance:Model;
		/* Serveur */
		public var server : String = "localhost";
		public var port   : uint = 5080; 
		public var appName: String = "visu2";
		
		private var listConnectedUsers:ArrayCollection = new ArrayCollection();
		private var listSwapUsers:ArrayCollection = new ArrayCollection();
		private var listSessions:ArrayCollection = new ArrayCollection();
		private var listFluxActivity:ArrayCollection = new ArrayCollection();
		private var listDateSession:ArrayCollection = new ArrayCollection();
		
		public var profiles:Array = [];
		
		private var _loggedUser:User;
		private var _netConnection:NetConnection;
		private var _userIdClient:String;
		private var _currentSession:Session = null;
		private var _tutoratModule:VisuModuleBase;
		private var _retroModule:VisuModuleBase;
		private var _userModule:VisuModuleBase;
		private var _homeModule:VisuModuleBase = null;
		
		private var _selectedDateLoggedUser:Object = null;
		
		private var listObsels:ArrayCollection;
		private var _beginTimeSalonSynchrone:Number;
	
		private var listTraceLine:ArrayCollection;

		private var _buttonSalonSynchrone:Button; 
		private var _listViewObselSessionOut:ArrayCollection = new ArrayCollection();
		
		// time of the serveur red5
		private var _timeServeur:Number;
		private var _timeJoinDECK:Number;
		
		public function Model(access:Private)
		{
			if (access == null)
			{
				// TODO MESSAGE
			}
			instance = this;
		}
		
		/**
		 * Returns the Singleton instance of the Application Model
		 */
		public static function getInstance() : Model
		{
			if (instance == null)
			{
				instance = new Model( new Private() );
			}
			
			return instance;
		}
		
		public function get AMFServer(): String
		{
			var portString:String = ":" + this.port;
			// check if port don't using in adress
			if (this.port == 0){
				portString = "";
			}
			return "http://" + this.server + portString + "/" + this.appName + "/gateway";
		}
		
		public function get rtmpServer(): String
		{
			return "rtmp://" + this.server + "/" + this.appName + "/" + "monSalon";
		}
		
		public function get urlServeur(): String
		{
			var portString:String = ":" + this.port;
			// check if port don't using in adress
			if (this.port == 0){
				portString = "";
			}
			return "http://" + this.server + portString + "/" + this.appName;
		}
		
		public function checkServeurVisuVciel():Boolean
		{
			if (this.appName == "visuvciel")
			{
				return true;
			}
			return false;
		}
		
		/**
		 *  set time of the serveur red5
		 */
		public function setTimeServeur(value:Number):void
		{
			this._timeServeur = value;
			// start synchronisation the time with serveur red5
			this._timeJoinDECK = new Date().time;
		}
		
		/**
		 * get calculated time of the serveur red5  
		 */
		public function getTimeServeur():Number
		{
			var timePresentsOnTheDeck:Number = new Date().time - this._timeJoinDECK;
			return this._timeServeur + timePresentsOnTheDeck;
		}
		
		public function setLoggedUser(value:UserVO):void
		{ 	
			_loggedUser = new User(value); 
			_loggedUser.setStatus(ConnectionStatus.PENDING);
		}
		
		public function getLoggedUser():User
		{
			return _loggedUser;
		}
		
		/**
		 * Update status of logged User 
		 */
		public function updateStatusLoggedUser(value:int):void
		{
			_loggedUser.status = value;
		}
		
		public function setNetConnection(value:NetConnection):void
		{
			_netConnection = value;
		}
		
		public function getNetConnection():NetConnection
		{
			return _netConnection;
		}
		
		/**
		 * set client id 
		 */
		public function setUserIdClient(value:String):void
		{
			_userIdClient = value;
		}
		
		/**
		 *  get client id
		 */
		public function getUserIdClient():String
		{
			return _userIdClient;
		}
		
		/**
		 * current session for tutorat module, only for debugging
		 */ 
		public function setCurrentSession(value:Session):void
		{
			_currentSession = value;
		}
		
		public function getCurrentSession():Session
		{
			return _currentSession;
		}
		
		/**
		 * 
		 */
		public function setButtonSalonSynchrone(value:Button):void
		{
			this._buttonSalonSynchrone = value;
		}
		
		public function setEnabledButtonSalonSynchrone(value:Boolean):void
		{
			this._buttonSalonSynchrone.enabled = value;
		}
		/**
		 * current tutorat module, only for debugging
		 */
		public function setCurrentTutoratModule(value:VisuModuleBase):void
		{
			_tutoratModule = value;
		}
		
		public function getCurrentTutoratModule():VisuModuleBase
		{
			return _tutoratModule;
		}
		
		/**
		 * current tutorat module, only for debugging
		 */
		public function setCurrentRetroModule(value:VisuModuleBase):void
		{
			_retroModule = value;
		}
		
		public function getCurrentRetroModule():VisuModuleBase
		{
			return _retroModule;
		}
		
		/**
		 * current user module, only for debugging
		 */
		public function setCurrentUserModule(value:VisuModuleBase):void
		{
			_userModule = value;
		}
		
		public function getCurrentUserModule():VisuModuleBase
		{
			return _userModule;
		}
		
		/**
		 * current user module, only for debugging
		 */
		public function setCurrentHomeModule(value:VisuModuleBase):void
		{
			_homeModule = value;
		}
		
		public function getCurrentHomeModule():VisuModuleBase
		{
			return _homeModule;
		}
		
		public function setSelectedItemNavigateurDayByLoggedUser(value:Object):void{
			_selectedDateLoggedUser = value;
		}
		
		public function getSelectedItemNavigateurDayByLoggedUser():Object
		{
			return _selectedDateLoggedUser;
		}
		public function setListSessions(arSession:Array):void
		{
			var nbrSession:uint = arSession.length;
			for (var nSession:uint = 0; nSession < nbrSession; nSession++)
			{
				var sessionVO:SessionVO = arSession[nSession];
				var session:Session = new Session(sessionVO);
				this.listSessions.addItem(session);
			}
		}
		
		public function setListSessionsByDate(arSession:Array, sessionDate:String):void
		{
			var listSessionByDate:ArrayCollection = new ArrayCollection();
			var nbrSession:uint = arSession.length;
			for (var nSession:uint = 0; nSession < nbrSession; nSession++)
			{
				var sessionVO:SessionVO = arSession[nSession];
				var session:Session = new Session(sessionVO);
				listSessionByDate.addItem(session);
			}
			var dateSessionsObject:Object =  getObjectDateSessions(sessionDate);
			// TODO check if null
			dateSessionsObject.listSessionDate = listSessionByDate;
		}
		
		public function getListSessionByDate(sessionDate:String):ArrayCollection
		{
			var dateSessionObject:Object = getObjectDateSessions(sessionDate);
			if (dateSessionObject != null){
				return dateSessionObject.listSessionDate;
			}else
				return null;
		}
		
		/**
		 * Set list obsels 
		 */
		public function setListObsel(listObsels:ArrayCollection):void
		{
			this.listObsels = listObsels;
		}
		
		/**
		 * Get list obsels
		 */
		public function getListObsels():ArrayCollection
		{
			return this.listObsels;
		}
		
		/**
		 * check if user enter in the session second time
		 */
		public function isFirstEnterSession(userId:int):Boolean
		{
			var result:Boolean = true;
			var arr:Array = new Array();
		//	var userId:int = this._loggedUser.id_user;
			if(this.listObsels != null)
			{
				var nbrObsel:int = this.listObsels.length;
				for(var nObsel:int = 0; nObsel < nbrObsel ; nObsel++)
				{
					var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
					var typeObsel:String = obsel.type;
					if(typeObsel == TraceModel.SESSION_OUT && obsel.props[TraceModel.UID] == userId)
					{
						arr.push(obsel);
					}
				}			
			}
			var nbrObselSessionOut:int = arr.length;
			// for first enter in the session only one obsel "sessionOut"
			if(nbrObselSessionOut > 1)
			{
				result = false;
			}
			return result;	
		}
		/**
		 * get list obsel "SessionIn" for this moment the time
		 */
		public function getObselSessionInByTimestamp(value:Number):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			var nbrObsel:int = this.listObsels.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
				var typeObsel:String = obsel.type;
				if(typeObsel == TraceModel.SESSION_IN)
				{
					var begin:Number = obsel.begin;
					var end:Number = obsel.end;
					if(begin < value && value < end)
					{
						result.addItem(obsel);	
					}
				}
			}
			return result;
		}
		
		public function getObselSessionInByPathStream(value:String):Obsel
		{
			var nbrObsel:int = this.listObsels.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel:Obsel = this.listObsels.getItemAt(nObsel) as Obsel;
				var typeObsel:String = obsel.type;
				if(typeObsel == TraceModel.SESSION_IN)
				{
					var pathStream:String = obsel.props[TraceModel.PATH];
					if(pathStream == value)
					{
						return obsel;
					}
				}
			}
			return null;
		}
			
		public function setBeginTimeSalonSynchrone(value:Number):void
		{
			_beginTimeSalonSynchrone=value;
		}
		
		public function getBeginTimeSalonSynchrone():Number
		{
			return this._beginTimeSalonSynchrone;
		}
		public function setSS(value:ArrayCollection):void
		{
			var listElementsTraceLine:ArrayList = this.listTraceLine[0] as ArrayList;
			var obj:Object = listElementsTraceLine.getItemAt(0);
			obj.listObsel = value;
		}
		
		public function getListTraceLines():ArrayCollection
		{
			return this.listTraceLine;
		}
		
		public function initListTraceLine():void
		{
			this.listTraceLine = new ArrayCollection();
		}
		public function addTraceLine(userId:int, userName:String, userAvatar:String, userColor:String):void
		{
			// check if this user include in listTraceLines
			if(!hasTraceLineByUserId(userId))
			{
				var listElementsTraceLine:ArrayList = new ArrayList();
				listElementsTraceLine.addItem({id: 0, titleTraceLine: "instruction", colorTraceLine : 454545, visible : false, listObsel: new ArrayCollection(), added : false});
				listElementsTraceLine.addItem({id: 1, titleTraceLine: "keyword", colorTraceLine : 454545, visible : false, listObsel: new ArrayCollection(), added : false});
				listElementsTraceLine.addItem({id: 2, titleTraceLine: "document", colorTraceLine : 454545, visible : false, listObsel: new ArrayCollection(), added : false});
				listElementsTraceLine.addItem({id: 3, titleTraceLine: "message", colorTraceLine : 454545, visible : false, listObsel: new ArrayCollection(), added : false});
				listElementsTraceLine.addItem({id: 4, titleTraceLine: "marker", colorTraceLine : 454545, visible : false, listObsel: new ArrayCollection(), added : true});
				this.listTraceLine.addItem({userId: userId, show: false, userName:userName, userAvatar: userAvatar, userColor: userColor, listTitleObsels: new ArrayCollection(), listElementTraceLine : listElementsTraceLine });	
			}
		}
		/**
		 * update new text and tooltips the obsel marker
		 */
		public function updateTextObselMarker(userId:int , timeStampUpdatedObsel:Number , text:String, typeObsel:String):void
		{
			var traceLine:Object = this.getTraceLineByUserId(userId);
			var listTitleObsels:ArrayCollection = traceLine.listTitleObsels;
			var obselView:ObselMarker = updateTextObsel(listTitleObsels, timeStampUpdatedObsel);
			if(obselView != null && typeObsel == TraceModel.UPDATE_MARKER)
			{
				var newObselView:ObselMarker = obselView.cloneMe();
				newObselView.text = text;
				newObselView.toolTip = text;
				var order:int = newObselView.order;
				listTitleObsels.addItemAt(newObselView, order);
			}
			var traceLineElementList:ArrayList = traceLine.listElementTraceLine;
			var traceLineElement:Object = traceLineElementList.getItemAt(4);
			var listMarkerObsel:ArrayCollection = traceLineElement.listObsel;
			var obselViewElement:ObselMarker = updateTextObsel(listMarkerObsel, timeStampUpdatedObsel);
			if(obselViewElement != null && typeObsel == TraceModel.UPDATE_MARKER)
			{
				var newObselView:ObselMarker = obselViewElement.cloneMe();
				newObselView.text = text;
				newObselView.toolTip = text;
				var order:int = newObselView.order;
				listMarkerObsel.addItemAt(newObselView,order);
			}
			
			function updateTextObsel(listObsels:ArrayCollection, timeStampUpdatedObsel:Number):ObselMarker
			{
				var nbrObsel:int = listObsels.length;
				for(var nObsel:int = 0 ; nObsel < nbrObsel ; nObsel++)
				{
					var obselView = listObsels.getItemAt(nObsel);
					if(obselView is ObselMarker){
						var obsel:Obsel = obselView.parentObsel;
						if(obsel != null && (obsel.type == TraceModel.SET_MARKER || obsel.type == TraceModel.RECEIVE_MARKER ))
						{
							var timeStamp:Number = obsel.props[TraceModel.TIMESTAMP];
							if(timeStamp == timeStampUpdatedObsel)
							{
								listObsels.removeItemAt(nObsel);
								obselView.order = nObsel;
								return obselView;
							}
						}
					}
				}
				return null;
			}	
		}
		
		/**
		 * add list obsel to title trace line
		 */
		public function addListObselTitleTraceLine(userId:int , listObsel:ArrayCollection):void
		{
			var traceLine:Object = this.getTraceLineByUserId(userId);
			var listTitleObsel:ArrayCollection = traceLine.listTitleObsels as ArrayCollection;
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0 ; nObsel < nbrObsel ; nObsel++)
			{
				var obsel = listObsel.getItemAt(nObsel);	
				// clone obsel, can't have same(one) obsel on too traceLine
				var newObsel = obsel.cloneMe();
				listTitleObsel.addItem(newObsel);
			}
		}
		
		/**
		 * remove list obsel to title trace line
		 */
		public function removeListObselTitleTraceLine(userId:int , listObsel:ArrayCollection):void
		{
			var traceLine:Object = this.getTraceLineByUserId(userId);
			var listTitleObsel:ArrayCollection = traceLine.listTitleObsels as ArrayCollection;
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0 ; nObsel < nbrObsel ; nObsel++)
			{
				var obsel = listObsel.getItemAt(nObsel);	
				// remove cloned obsel
				removeClonedObsel(listTitleObsel, obsel);
			}
		}
		
		/**
		 * remove obsel by property "begin" 
		 */
		private function removeClonedObsel(listObsel:ArrayCollection , obselOrigin:*):void
		{
			var nbrObsel:int = listObsel.length;
			for(var nObsel:int = 0; nObsel < nbrObsel; nObsel++)
			{
				var obsel = listObsel.getItemAt(nObsel);
				if(obsel.getBegin() == obselOrigin.getBegin())
				{
					listObsel.removeItemAt(nObsel);
					return;
				}
			}
			return;
		}
		/**
		 * checking if has users trace line
		 */
		private function hasTraceLineByUserId(userId:int):Boolean
		{
			if(this.listTraceLine != null)
			{
				var nbrTraceLines:int = this.listTraceLine.length;
				for(var nTraceLine:int = 0; nTraceLine < nbrTraceLines; nTraceLine++)
				{
					var traceLine:Object = this.listTraceLine[nTraceLine] as Object;
					var id:int = traceLine.userId;
					if(id == userId)
					{
						return true;
					}
				}
				return false;
			}
			// FIXME : it's hapen when user in Accuiel , and other user start recording
			this.initListTraceLine();
			return false;
		}
		
		/**
		 * 
		 */
		public function getTraceLineByUserId(userId:int):Object
		{
			var nbrTraceLines:int = this.listTraceLine.length;
			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLines; nTraceLine++)
			{
				var traceLine:Object = this.listTraceLine[nTraceLine] as Object;
				var id:int = traceLine.userId;
				if(id == userId)
				{
					return traceLine;
				}
			}
			return null;
		}
		
		/**
		 * create view obsel and add on the traceLine
		 */
		public function addObsel(obsel:Obsel):Array
		{
			var result:Array = new Array();
			var typeObsel:String = obsel.type;
			var viewObsel = new ObselImage()
			viewObsel.setBegin(obsel.begin);
			viewObsel.setEnd(obsel.end);
			var textObsel:String;
			var ownerObsel:int;
			switch (typeObsel)
			{
				case TraceModel.STOP_VIDEO:
				case TraceModel.PRESS_SLIDER_VIDEO:
				case TraceModel.RELEASE_SLIDER_VIDEO:
				case TraceModel.PLAY_VIDEO:
				case TraceModel.PAUSE_VIDEO:
				case TraceModel.END_VIDEO:
					ownerObsel = obsel.props[TraceModel.SENDER];
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.TEXT];
					var currentTimePlayer:String = obsel.props[TraceModel.CURRENT_TIME_PLAYER];
					viewObsel.toolTip = textObsel+"("+currentTimePlayer+"s.)";
					break;
				case TraceModel.SET_MARKER :
					viewObsel = new ObselMarker()
					viewObsel.setBegin(obsel.begin);
					viewObsel.setEnd(obsel.end);
					viewObsel.parentObsel = obsel;
					ownerObsel = obsel.uid;
					viewObsel.source = IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.TEXT];
					viewObsel.text = textObsel;
					viewObsel.toolTip = textObsel;
					var backGroundColorObsel:uint = Model.getInstance().getTraceLineByUserId(ownerObsel).userColor;
					viewObsel.backGroundColor = backGroundColorObsel;
					break;
				case TraceModel.RECEIVE_MARKER :
					viewObsel = new ObselMarker();
					viewObsel.setBegin(obsel.begin);
					viewObsel.setEnd(obsel.end);
					viewObsel.parentObsel = obsel;
					ownerObsel = obsel.props[TraceModel.SENDER];
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.TEXT];
					viewObsel.text = textObsel;
					viewObsel.toolTip = textObsel;
					var backGroundColorObsel:uint = Model.getInstance().getTraceLineByUserId(ownerObsel).userColor;
					viewObsel.backGroundColor = backGroundColorObsel;
					break;
				case TraceModel.SEND_CHAT_MESSAGE :
					ownerObsel = obsel.uid;
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.CONTENT];
					viewObsel.toolTip = textObsel;
					break;
				case TraceModel.RECEIVE_CHAT_MESSAGE :
					ownerObsel = obsel.uid;
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.CONTENT];
					var labelSender:String ="";
					if(!checkServeurVisuVciel())
					{
						labelSender = obsel.props[TraceModel.SENDER]+":"; 
					}
					viewObsel.toolTip =  labelSender + textObsel;
					var senderObsel:int = obsel.props[TraceModel.SENDER];
					result.push({senderId:senderObsel, textObsel:textObsel, source:viewObsel.source});
					break;
				case TraceModel.SEND_KEYWORD :
					ownerObsel = obsel.uid;
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.KEYWORD];
					viewObsel.toolTip = textObsel;
					break;
				case TraceModel.RECEIVE_KEYWORD :
					ownerObsel = obsel.uid;
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.KEYWORD];
					viewObsel.toolTip = textObsel;
					var senderObsel:int = obsel.props[TraceModel.SENDER];
					result.push({senderId:senderObsel, textObsel:textObsel, source:viewObsel.source});
				//	initChatPanel(senderObsel, textObsel, viewObsel.source as Class, sessionReadyInit);
					break;
				case TraceModel.SEND_INSTRUCTIONS :
					ownerObsel = obsel.uid;
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.INSTRUCTIONS];
					viewObsel.toolTip = textObsel;
					break;
				case TraceModel.RECEIVE_INSTRUCTIONS :
					ownerObsel = obsel.uid;
					viewObsel.source =  IconEnum.getIconByTypeObsel(typeObsel);
					textObsel = obsel.props[TraceModel.INSTRUCTIONS];
					viewObsel.toolTip = textObsel;
					var senderObsel:int = obsel.props[TraceModel.SENDER];
					result.push({senderId:senderObsel, textObsel:textObsel, source:viewObsel.source});
			//		initChatPanel(senderObsel, textObsel, viewObsel.source as Class, sessionReadyInit);
					break;
				case TraceModel.SEND_DOCUMENT :
					ownerObsel = obsel.uid;
					var typeDocument:String = obsel.props[TraceModel.TYPE_DOCUMENT]; 
					if(typeDocument == ActivityElementType.IMAGE)
					{
						viewObsel.source =  obsel.props[TraceModel.URL];  
					}else
					{
						viewObsel.source = IconEnum.getIconByTypeObsel(typeObsel);
					}
					textObsel = obsel.props[TraceModel.TEXT];
					viewObsel.toolTip = textObsel;
					break;
				case TraceModel.RECEIVE_DOCUMENT :
					ownerObsel = obsel.uid;
					var typeDocument:String = obsel.props[TraceModel.TYPE_DOCUMENT]; 
					if(typeDocument == ActivityElementType.IMAGE)
					{
						viewObsel.source =  obsel.props[TraceModel.URL];  
					}else
					{
						viewObsel.source = IconEnum.getIconByTypeObsel(typeObsel);
					}
					textObsel = obsel.props[TraceModel.TEXT];
					viewObsel.toolTip = textObsel;
					var senderObsel:int = obsel.props[TraceModel.SENDER];
					result.push({senderId:senderObsel, textObsel:textObsel, source:viewObsel.source});
				//	initChatPanel(senderObsel, textObsel, fichierIconVisu1 , sessionReadyInit);
					break;
				case TraceModel.READ_DOCUMENT :
					ownerObsel = obsel.props[TraceModel.SENDER];
					var typeDocument:String = obsel.props[TraceModel.TYPE_DOCUMENT]; 
					if(typeDocument == ActivityElementType.IMAGE)
					{
						viewObsel.source =  obsel.props[TraceModel.URL];  
					}else
					{
						viewObsel.source = IconEnum.getIconByTypeObsel(typeObsel);
					} 			
					textObsel = obsel.props[TraceModel.TEXT];
					viewObsel.toolTip = obsel.props[TraceModel.SENDER_DOCUMENT] + ":" + textObsel;
					break;
				//case TraceModel.SESSION_IN :
				case TraceModel.SESSION_OUT :		
					viewObsel = new ObselSessionOut()
					viewObsel.setBegin(obsel.begin);
					viewObsel.setEnd(obsel.end);
					ownerObsel = obsel.props[TraceModel.UID];
					break;
				case TraceModel.SESSION_OUT_VOID_DURATION :
					ownerObsel = obsel.props[TraceModel.UID];
					viewObsel = new ObselSessionOut()
					viewObsel.setBegin(obsel.begin);
					viewObsel.setEnd(obsel.end);
					viewObsel.setOwner(ownerObsel);
					// add viewObsel for updating his duration
					this._listViewObselSessionOut.addItem(viewObsel);
					// add viewObsel like "SessionOut"
					typeObsel = TraceModel.SESSION_OUT;
					break;
			}
			
			Model.getInstance().setObsel(viewObsel,ownerObsel,typeObsel)
				
			return result;
		}

		public function setObsel(obsel:*, userId:int, typeObsel:String):void
		{
			var traceLine:Object = getTraceLineByUserId(userId);
			if(traceLine == null)
			{
				// TODO message
				return;
			}
			var listElementTraceLine:ArrayList = traceLine.listElementTraceLine as ArrayList;
			var traceLineElement:Object;
			var tempTitleListObsel:ArrayCollection =  traceLine.listTitleObsels as ArrayCollection;
				// set traceLineElements: instruction, keyword, document, messages, marker
				switch (typeObsel)
				{
					case TraceModel.SEND_INSTRUCTIONS:
					case TraceModel.RECEIVE_INSTRUCTIONS:
						traceLineElement = listElementTraceLine.getItemAt(0) as Object;	
						break;
					case TraceModel.SEND_KEYWORD:
					case TraceModel.RECEIVE_KEYWORD:
						traceLineElement = listElementTraceLine.getItemAt(1) as Object;	
						break;
					case TraceModel.SEND_DOCUMENT:
					case TraceModel.RECEIVE_DOCUMENT:
					case TraceModel.READ_DOCUMENT:
					case TraceModel.STOP_VIDEO:
					case TraceModel.PRESS_SLIDER_VIDEO:
					case TraceModel.RELEASE_SLIDER_VIDEO:
					case TraceModel.PLAY_VIDEO:
					case TraceModel.PAUSE_VIDEO:
					case TraceModel.END_VIDEO:
						traceLineElement = listElementTraceLine.getItemAt(2) as Object;	
						break;
					case TraceModel.SEND_CHAT_MESSAGE:
					case TraceModel.RECEIVE_CHAT_MESSAGE:
						traceLineElement = listElementTraceLine.getItemAt(3) as Object;	
						break;
					case TraceModel.SET_MARKER:
					case TraceModel.RECEIVE_MARKER:
					case TraceModel.SESSION_IN:
						traceLineElement = listElementTraceLine.getItemAt(4) as Object;	
						break;
					case TraceModel.SESSION_OUT:
						// add obsel "SessionOut" only in thaceLineTitle
						tempTitleListObsel.addItem(obsel);
						return;
						break;
					default:		
				}
				// add obsel on the traceLineElement
				var lObsel:ArrayCollection =  traceLineElement.listObsel as ArrayCollection;
				if(lObsel == null)
				{
					lObsel = new ArrayCollection();
					lObsel.addItem(obsel);
					traceLineElement.listObsel = lObsel;
				}else
				{
					lObsel.addItem(obsel);
				}
				
				// check if need add obsel to titleTrcaLine
				var addedTraceLine:Boolean = traceLineElement.added;
				if(addedTraceLine)
				{
					var newObsel = obsel.cloneMe();
					tempTitleListObsel.addItem(newObsel);
				}	
		}
		
		public function getListElementsTraceLineByUserId(userId:int):ArrayList
		{
			var traceLine:Object = getTraceLineByUserId(userId);
			if(traceLine == null)
			{
				// TODO message
				return null;
			}
			var listElementsTraceLine:ArrayList = traceLine.listElementTraceLine as ArrayList;
			var nbrElements:int = listElementsTraceLine.length;
			for(var nElement:int=0; nElement < nbrElements; nElement++)
			{
				var objTraceLineElement:Object = listElementsTraceLine.getItemAt(nElement);
				var visible:Boolean = objTraceLineElement.visible;
				if(!visible)
				{
					objTraceLineElement.visible = true;
					return listElementsTraceLine;
				}
			}
			return listElementsTraceLine;
		}
		
		public function setUnvisibleElementTraceLineByUser(idElement:int, userId:int):void
		{
			var traceLine:Object = getTraceLineByUserId(userId);
			if(traceLine == null)
			{
				// TODO message
			}
			var listElementsTraceLine:ArrayList = traceLine.listElementTraceLine as ArrayList;
			var nbrElements:int = listElementsTraceLine.length;
			for(var nElement:int =0; nElement < nbrElements; nElement++)
			{
				var objTraceLineElement:Object = listElementsTraceLine.getItemAt(nElement);
				if(objTraceLineElement.id == idElement)
				{
					objTraceLineElement.visible = false;
					return;
				}
			}	
		}
		
		public function getObjectDateSessions(dateSession:String):Object
		{
			var nbrObjects:int = this.listDateSession.length;
			for(var nObject:int = 0; nObject < nbrObjects; nObject++){
				var obj:Object = this.listDateSession[nObject];
				var labelDate:String = obj.labelDate as String;
				if(labelDate == dateSession)
				{
					return obj;
				}
			}
			return null;
		}
		
		/**
		 * remove session when user sing out from this session by responsable
		 */
		public function removeSession(sessionVO:SessionVO):String
		{
			var labelDate:String = getDateFormatYYY_MM_DD(sessionVO.date_session);	
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var dateSession:String = obj.labelDate;				
				if (dateSession == labelDate){
					var listSessionDate:ArrayCollection = obj.listSessionDate;
					var session:Session = this.getSessionById(sessionVO.id_session, listSessionDate);
					if(session != null)
					{
						var indexRemoveSession:int = listSessionDate.getItemIndex(session);
						listSessionDate.removeItemAt(indexRemoveSession);
						//checking if no more session by this date
						var nbrSession:uint = listSessionDate.length;
						if(nbrSession == 0)
						{
							var indexRemovedSessionDate:int = this.listDateSession.getItemIndex(obj);
							this.listDateSession.removeItemAt(indexRemovedSessionDate);
						}
						return labelDate;
					}				
				}					
			}
			return "";	
		}
		
		/**
		 * add session for user when responsable add him to this session 
		 */
		public function addSession(sessionVO:SessionVO, listUsers:Array):String{
			var labelDate:String = getDateFormatYYY_MM_DD(sessionVO.date_session);			
			var session:Session = new Session(sessionVO);
			session.setUsers(listUsers);
			// add swap users
			this.setSwapUsers(session.participants);
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var dateSession:String = obj.labelDate;				
				if (dateSession == labelDate){
						var listSessionDateTemp:ArrayCollection = obj.listSessionDate;
						if(listSessionDateTemp == null)
						{
							listSessionDateTemp = new ArrayCollection();	
						}
						listSessionDateTemp.addItem(session);
						return labelDate;
				}					
			}
			// add new date and session
			var listSessionDate:ArrayCollection = new ArrayCollection();
			listSessionDate.addItem(session);
			var index:int = this.getIndexDateSession(sessionVO.date_session);		
			this.listDateSession.addItemAt({labelDate:labelDate, fullDate:sessionVO.date_session, listSessionDate:listSessionDate},index);			
			return labelDate;
		}
		
		/**
		 * Get index of element date where will be add new date of the sesion
		 */
		private function getIndexDateSession(date:Date):int
		{
			var nbrDate:uint = this.listDateSession.length;
			if(nbrDate == 0){
				return 0;
			}else
			{
				for(var nDate:int = 0; nDate < nbrDate; nDate++){
					var obj:Object = this.listDateSession[nDate] as Object;
					var dateObject:Date = obj.fullDate as Date;
					var diff:Number = dateObject.getTime() - date.getTime();
					if(diff > 0)
					{
						return nDate
					}
				}
				return nDate;
			}	
		}
		
		/**
		 * set list participants of this session 
		 */
		public function setListUsersSession(arUser:Array, sessionId:int):void
		{
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var listSessionDate:ArrayCollection = obj.listSessionDate;
				var session:Session = this.getSessionById(sessionId,listSessionDate);
				if (session != null){
					session.setUsers(arUser);
					this.setSwapUsers(session.participants);
					return;
				}					
			}
		}

		private function getSessionById(sessionId:int, listSession:ArrayCollection):Session
		{
			if(listSession == null){ return null};
			var nbrSession:uint = listSession.length;
			if (nbrSession == 0) return null;
			for(var nSession:uint = 0; nSession < nbrSession; nSession++ )
			{
				var session:Session = listSession[nSession];
				var id:int = session.getSessionId();
				if(sessionId == id)
				{
					return session; 
				}
			}
			return null;
		}
		/**
		 * check if user has this session
		 */
		public function hasSessionById(sessionId:int):Session
		{
			var nbrDateSessionObject:Object = this.listDateSession.length;
			for(var nDateSessionObject:uint = 0; nDateSessionObject < nbrDateSessionObject; nDateSessionObject++){
				var obj:Object = this.listDateSession[nDateSessionObject];
				var listSessionDate:ArrayCollection = obj.listSessionDate;
				var session:Session = this.getSessionById(sessionId,listSessionDate);
				if(session != null){					
					return session;
				}					
			}
			return null;
		}

		/**
		 * get dates of the sessions
		 */
		public function getSessionDates():ArrayCollection
		{
			var nbrSession:uint = this.listSessions.length;
			if (nbrSession == 0) return null;
			var listDate:ArrayCollection = new ArrayCollection();			
			for(var nSession:uint = 0; nSession < nbrSession; nSession++ )
			{
				var session:Session = this.listSessions[nSession];
				var date:Date = session.getSessionDate();
				if (!this.hasSameDate(listDate, date))
				{
					listDate.addItem(date);
				}
			}
			return listDate;
		}
		
		/**
		 * get list session 
		 */ 
		public function getSessionByDay(date:Date):ArrayCollection
		{
			var nbrSession:uint = this.listSessions.length;
			if (nbrSession == 0) return null;
			var listSession:ArrayCollection = new ArrayCollection();			
			for(var nSession:uint = 0; nSession < nbrSession; nSession++ )
			{
				var session:Session = this.listSessions[nSession];
				var dateSession:Date = session.getSessionDate();
				if ((dateSession.date == date.date) && (dateSession.month == date.month) && (dateSession.fullYearUTC == date.fullYearUTC))
				{
					listSession.addItem(session);
				}
			}
			return listSession;
		}
		
		/**
		 * checking if we have the same date 
		 */
		private function hasSameDate(ar:ArrayCollection , date:Date ):Boolean
		{
			var nbrDay:uint = ar.length;
			if(nbrDay == 0) { return false};
			var day:Number = date.date;
			var mont:Number = date.month;
			var year:Number = date.fullYearUTC;
			for(var nDay:uint = 0; nDay < nbrDay ; nDay++)
			{
				var elm:Date = ar[nDay];
				if ((elm.date == day) && (elm.month == mont) && (elm.fullYearUTC == year) )
				{
					return true;
				}
			}
			return false;
		}	
		
		public function hasSession(sessionId:uint):Boolean{
			var nbrSession:uint = this.listSessions.length;
			for(var nSession:uint = 0; nSession < nbrSession ; nSession++){
				var session:Session = this.listSessions[nSession];
				var id:uint = session.getSessionId();
				if(id == sessionId){
					return true;
				}
			}
			return false;
		}

		
		public function getListSessions():ArrayCollection
		{
			return this.listSessions;
		}
		
		/**
		 * set list date 
		 */
		public function setSessionDate(ar:Array):void
		{
			var nbrDates:uint = ar.length;
			for(var nDate:uint = 0; nDate < nbrDates ; nDate++){
				var dateString:String = ar[nDate] as String;
				var arrDate:Array = dateString.split("-");
				// create new date similaire like on the serveur
				var date:Date = new Date(new Number(arrDate[0]), new Number(arrDate[1]),new Number(arrDate[2]));
				var labelDate:String = getDateFormatYYY_MM_DD(date);
				this.listDateSession.addItem({labelDate:labelDate, fullDate:date, listSessionDate:null});
			}
		}
		
		public function addSessionDateToday(index:int):Object
		{
			var date:Date = new Date();
			var labelDate:String = getDateFormatYYY_MM_DD(date);
			this.listDateSession.addItemAt({labelDate:labelDate, fullDate:date, listSessionDate:null},index);
			return this.listDateSession.getItemAt(index);
		}
		public function hasDateSession():Boolean
		{
			if(this.listDateSession.length > 0)
			{
				return true;
			}else return false;
		}
		
		public function getSessionDate():ArrayCollection
		{
			return this.listDateSession;
		}
		
		/**
		 * set connected users 
		 */
		public function setConnectedUsers(ar:Array):void
		{
			var nbrUser:uint = ar.length;
			if(nbrUser == 0) { return };
			for(var nUser:uint = 0; nUser < nbrUser; nUser++)
			{
				var infoUser:Array = ar[nUser];
				var status:int = infoUser[0];
				var userVO:UserVO = infoUser[1];
				var user:User = new User(userVO);
				user.setStatus(status);
				user.id_client=infoUser[2];
				user.currentSessionId = infoUser[3];
				this.listConnectedUsers.addItem(user);
				// add set swapUsers
				this.listSwapUsers.addItem(user);
			}
		}
		
		public function getConnectedUsers():ArrayCollection
		{
			return this.listConnectedUsers;
		}
		
		public function getConnectedUserExcludeLoggedUser():ArrayCollection
		{
			var listConnectedUserExcludeLoggedUser:ArrayCollection = new ArrayCollection();
			var nbrConnectedUser:uint = this.listConnectedUsers.length;
			for(var nConnectedUser:uint = 0; nConnectedUser < nbrConnectedUser ; nConnectedUser++)
			{
				var user:User = this.listConnectedUsers[nConnectedUser];
				if(user != _loggedUser)
				{
					listConnectedUserExcludeLoggedUser.addItem(user);
				}
			}
			return listConnectedUserExcludeLoggedUser;
		}
		
		public function getSwapUsers():ArrayCollection
		{
			return this.listSwapUsers;
		}
		
		public function getFluxActivity():ArrayCollection
		{
			return this.listFluxActivity;
		}
		
		public function addFluxActivity(userId:int, firstname:String, path:String, message:String , date:Date):void
		{
			var h:String = date.getHours().toString();
			var zeroMin:String = "";
			if (date.getMinutes() < 10)
			{
				zeroMin = "0";
			}
			var m:String = zeroMin+date.getMinutes().toString();
			var time:String = h+":"+m;
			var fluxActivity:FluxActivity = new FluxActivity(userId,firstname,path,message,time);
			this.listFluxActivity.addItemAt(fluxActivity,0);		
		}
		
		public function removeConnectedUser(userId:int):void
		{
			var nbrUser:uint = this.listConnectedUsers.length;
			if(nbrUser == 0) { return };
			for(var nUser:uint = 0; nUser < nbrUser; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				var id:int = user.getId();
				if(id == userId)
				{
					this.listConnectedUsers.removeItemAt(nUser);
					//set swap user disconnected
					this.addSwapUser(user, ConnectionStatus.DISCONNECTED);
					return;
				}			
			}			
		}
		
		public function addConnectedUsers(userVO:UserVO):void
		{
			var user:User = new User(userVO);
			user.setStatus(ConnectionStatus.PENDING);
			this.listConnectedUsers.addItem(user);
			// add swap user
			this.addSwapUser(user, ConnectionStatus.PENDING);
		}
		
		
		public function setSwapUsers(listSessionUsers:ArrayCollection):void{
			var nbrSessionUsers:uint = listSessionUsers.length;
			for(var nSessionUser:uint = 0; nSessionUser < nbrSessionUsers; nSessionUser++){
				var sessionUser:User = listSessionUsers[nSessionUser] as User;
				addSwapUser(sessionUser);				
			}
		}
		
		private function addSwapUser(user:User, status:int = -1):void{
			var nbrSwapUsers:uint = this.listSwapUsers.length;
			for(var nSwapUser:uint = 0; nSwapUser < nbrSwapUsers; nSwapUser++){
				var swapUser:User = this.listSwapUsers[nSwapUser] as User;
				var swapUserId:uint = swapUser.getId();
				var userId:uint = user.getId();
				if(swapUserId == userId){
					if(status != -1){
						swapUser.setStatus(status);
					}
					return;
				}
			}
			this.listSwapUsers.addItem(user);		
		}	
		
		/**
		 * update status connected user, when user walk out fro salon tutorat 
		 */
		public function updateStatusUser(userVO:UserVO, status:int, sessionId:int):void
		{
			this.updateStatusUserFromList(userVO, this.listConnectedUsers, status, sessionId);
			this.updateStatusUserFromList(userVO, this.listSwapUsers, status, sessionId);
		}
		
		/**
		 * update status user  
		 */
		private function updateStatusUserFromList(userVO:UserVO, listUsers:ArrayCollection, status:int, sessionId:int):void{
			var nbrUsers:uint = listUsers.length;
			for(var nUser:uint =0; nUser < nbrUsers; nUser++)
			{ 
				var user:User = listUsers[nUser] as User;
				var userId:int = user.id_user;
				if(userId == userVO.id_user)
				{
					user.status = status;
					user.currentSessionId = sessionId;
				}
			}
		}
		
		/**
		 * get list client id of the connected users
		 */
		public function getListIdClient(sessionId:int):Array
		{
			var result:Array = new Array();
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				var idClient:String = this.getIdClient(user.id_user);
				var status:int = user.status;
				var currentSessionUser:int = user.currentSessionId;
				if((idClient != "") && (status == ConnectionStatus.CONNECTED || status == ConnectionStatus.RECORDING) && (currentSessionUser == sessionId))
				{
					//add idClient only if status Connected or Recording
					result.push(idClient);				
				}
			}
			return result;
		}
		
		/**
		 * update duration viewObsels "SessionOut" 
		 */
		public function setTimeViewObselSessionOut(value:Number):void
		{
			var viewObsel:ObselSessionOut;
			for each(viewObsel in this._listViewObselSessionOut)
			{
				viewObsel.setEnd(value);	
			}
		}
		
		/**
		 * add viewObsel "SessionOut" 
		 */
		public function addViewObselSessionOut(timeBegin:Number, userId:int):void
		{
			var viewObsel:ObselSessionOut = new ObselSessionOut();
			viewObsel.setOwner(userId);
			viewObsel.setBegin(timeBegin);
			viewObsel.setEnd(timeBegin+100);
			this.setObsel(viewObsel,userId,TraceModel.SESSION_OUT);
			this._listViewObselSessionOut.addItem(viewObsel);
			
		}
		/**
		 * remove viewObsel "SessionOut"
		 */
		public function removeViewObselSessionOut(userId:int):Boolean
		{
			var result:Boolean = false;
			var listSameOwnerObsel:ArrayCollection  = new ArrayCollection();
			var nbrViewObsel:int = this._listViewObselSessionOut.length;
			for(var nViewObsel:int ; nViewObsel < nbrViewObsel ; nViewObsel++)
			{
				var viewObsel:ObselSessionOut = this._listViewObselSessionOut.getItemAt(nViewObsel) as ObselSessionOut;
				var owner:int = viewObsel.getOwner();
				if(owner == userId)
				{
					//this._listViewObselSessionOut.removeItemAt(nViewObsel);
					listSameOwnerObsel.addItem(nViewObsel);
				//	return true;
				}
			}		
			var nbrSameObsel:int = listSameOwnerObsel.length;
			for(var nSameObsel:int = nbrSameObsel; nSameObsel > 0 ; nSameObsel--  )
			{
				var orderSameObselInList:int = listSameOwnerObsel.getItemAt(nSameObsel-1) as int;
				this._listViewObselSessionOut.removeItemAt(orderSameObselInList);
			}	
			if(nbrSameObsel > 0)
			{
				result =  true
			}
			return result;
		}
		
		public function removeObselSessionOutCurrentUser(sessionId:int):void
		{
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
			var nbrTraceLine:int = listTraceLine.length;
			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
			{
				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
				// id of the user having traceLine
				var userId:int = traceLine.userId;
				if(hasUserInSession(listUserId,userId))
				{
					// stop MAJ duration of the obsel "SessionOut"
					this.removeViewObselSessionOut(userId);
				}
			}
		}
		/**
		 * paused session  => add obsel "SessionOut" for all users
		 */
		public function setObselSessionOutForAllUser(sessionId:int):void
		{
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
			var nbrTraceLine:int = listTraceLine.length;
			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
			{
				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
				// id of the user having traceLine
				var userId:int = traceLine.userId;
				var viewObsel:ObselSessionOut = new ObselSessionOut();
				viewObsel.setOwner(userId);
				viewObsel.setBegin(new Date().time);
				// TODO gestion currentTime
				viewObsel.setEnd(new Date().time + 100);
				this.addViewObselSessionOut(viewObsel.getBegin(), userId);
			}			
		}
		/**
		 * add obsel "SessionOut for user presents in the session, after click on boutton "stop recording"
		 */
		public function setObselSessionOutForCurrentUser(sessionId:int):void
		{
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
			var nbrTraceLine:int = listTraceLine.length;
			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
			{
				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
				// id of the user having traceLine
				var userId:int = traceLine.userId;
				if(hasUserInSession(listUserId,userId))
				{
					var viewObsel:ObselSessionOut = new ObselSessionOut();
					viewObsel.setOwner(userId);
					viewObsel.setBegin(new Date().time);
					// TODO gestion currentTime
					viewObsel.setEnd(new Date().time + 100);
					// show obsel on traceLine
	//				this.setObsel(viewObsel,userId,TraceModel.SESSION_OUT);
					// add obsel in the list for update duration
					this.addViewObselSessionOut(viewObsel.getBegin(), userId);
				}
			}		
		}
		/**
		 * set obsels "SessionOut" for users had walk out from TutoratModule 
		 * before creation "TimeLine" for logged user
		 */
		public function setObselSessionOutForUserWalkOutSession(session:Session, obsel:Obsel):void
		{
			var sessionId:int = session.id_session;
			var listUserId:Array = this.getListUsersIdByConnectedSession(sessionId);
			var listTraceLine:ArrayCollection = this.getListTraceLines();
			var nbrTraceLine:int = listTraceLine.length;
			for(var nTraceLine:int = 0; nTraceLine < nbrTraceLine ; nTraceLine++)
			{
				var traceLine:Object =  listTraceLine.getItemAt(nTraceLine) as Object;
				// id of the user having traceLine
				var userId:int = traceLine.userId;
				if(!hasUserInSession(listUserId,userId) && obsel != null)
				{
					// user walk out from session
					var obselSessionOut:Obsel = Obsel.fromRDF((obsel.toRDF()));
					obselSessionOut.type = TraceModel.SESSION_OUT_VOID_DURATION;
					obselSessionOut.props[TraceModel.UID] = userId.toString();
					obselSessionOut.end = obselSessionOut.begin + 100;
					// add obsel to collection the obsel for show in TimeLine
					this.listObsels.addItem(obselSessionOut);
				}
			}		
		}
		
		private function hasUserInSession(listUserId:Array, value:int):Boolean
		{
			var nbrUser:int = listUserId.length;
			for(var nUser:int = 0; nUser < nbrUser; nUser++)
			{
				var id:int = listUserId[nUser];
				if(id == value)
				{
					return true;	
				}
			}
			return false;
		}
		
		/**
		 * get list users id of the session 
		 */
		public function getListUsersIdByConnectedSession(sessionId:int):Array
		{
			var result:Array = new Array();
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.currentSessionId == sessionId)
				{
					//add userId only if user in this session(really, not planning)
					result.push(user.getId());				
				}
			}
			return result;
		}
		/**
		 * get list users id with status "RECORDING" of the recording session whitout logged user
		 */
		public function getListUsersIdByRecordingSessionWithoutLoggedUser(sessionId:int):Array
		{
			var result:Array = new Array();
			var loggedUserId:int = this._loggedUser.getId();
			var listUsersIdByRecordingSession:Array = this.getListUsersIdByRecordingSession(sessionId);
			var nbrIds:int = listUsersIdByRecordingSession.length;
			for(var nId:int = 0 ; nId < nbrIds ; nId++)
			{
				var id:int = listUsersIdByRecordingSession[nId]	as int;
				if(id != loggedUserId)
				{
					result.push(id);
				}
			}
			return result;
		}
		
		/**
		 * get list users id with status "RECORDING" of the recording session 
		 */
		public function getListUsersIdByRecordingSession(sessionId:int, role:int=0, filter:Boolean = false):Array
		{
			var status:int = ConnectionStatus.RECORDING;
			if(filter)
			{
				// have to add users with status recording and paused
				status = ConnectionStatus.CONNECTED;
			}
			var result:Array = new Array();
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers; nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if((user.status == ConnectionStatus.RECORDING || user.status == status) && (user.currentSessionId == sessionId))
				{
					//add userId only if status Recording of this sessionId
					if(role == 0 )
					{
						result.push(user.getId());				
					}
					else if( role < RoleEnum.TUTEUR)
						// will shared only with Tutor.....and with myself
						{
							if (user.role > RoleEnum.STUDENT || user.id_user == this._loggedUser.id_user)
							{
								result.push(user.getId());	
							}
						}
					else 
						// will shared only with himself
					{
						if(user.id_user == this._loggedUser.id_user)
						{
							result.push(user.getId());	
						}
					}
					
				}
			}
			return result;
		}
		
		public function getIdClient(userId:int):String
		{
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.id_user == userId)
				{
					return user.id_client;
				}
			}
			return "";
		}
		
		public function getUserByUserId(userId:int):User
		{
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.id_user == userId)
				{
					return user;
				}
			}
			return null;
		}
		
		/**
		 * update client id of the user
		 */
		public function updateUserIdClient(userVO:UserVO, idClient:String):void
		{
			var nbrUsers:uint = this.listConnectedUsers.length;
			for(var nUser:uint = 0; nUser < nbrUsers;nUser++)
			{
				var user:User = this.listConnectedUsers[nUser];
				if(user.id_user == userVO.id_user)
				{
					user.id_client = idClient;
					return;
				}
			}
		}
		
		/**
		 * 
		 */
		private function getDateFormatYYY_MM_DD(date:Date):String{
			var month:uint = date.getMonth()+1;
			var monthString:String = month.toString();
			if(month < 10){
				monthString = '0'+monthString;
			}
			var day:uint = date.date;
			var dayString:String = day.toString();
			if(day < 10){
				dayString = '0'+dayString;
			}
			return date.getFullYear().toString()+"-"+monthString+"-"+dayString;
		}	
	}
}

/**
 * Inner class which restricts constructor access to Private
 */
class Private {}